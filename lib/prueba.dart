import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:dio/dio.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  // Ubicación base (Mexicali)
  final LatLng _center = LatLng(32.6245, -115.4523);
  double _zoomLevel = 14;

  bool showGyms = false;
  bool showStores = false;

  // Lista general de marcadores
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    // Podemos cargar algo por defecto aquí si quieres
  }

  Future<void> _fetchPOIs() async {
    // Limpiamos marcadores previos
    List<Marker> newMarkers = [];

    // Llamados HTTP a Overpass API
    if (showGyms) {
      List<Marker> gymMarkers = await _getOverpassMarkers(
        categoryQuery: 'node["amenity"="gym"]',
      );
      newMarkers.addAll(gymMarkers);
    }
    if (showStores) {
      List<Marker> storeMarkers = await _getOverpassMarkers(
        categoryQuery: 'node["shop"="supermarket"]',
      );
      newMarkers.addAll(storeMarkers);
    }

    setState(() {
      _markers = newMarkers;
    });
  }

  // Función que construye la URL y obtiene JSON de Overpass
  Future<List<Marker>> _getOverpassMarkers({required String categoryQuery}) async {
    final lat = _center.latitude;
    final lon = _center.longitude;
    const radius = 2000; // 2km a la redonda

    // Overpass URL
    final overpassUrl = Uri.parse(
      'https://overpass-api.de/api/interpreter'
      '?data=[out:json];$categoryQuery(around:$radius,$lat,$lon);out;',
    );

    final dio = Dio();
    List<Marker> markersList = [];

    try {
      final response = await dio.get(overpassUrl.toString());
      final data = response.data;

      if (data != null && data['elements'] != null) {
        for (var element in data['elements']) {
          // Extraemos lat/lon
          double latNode = element['lat'];
          double lonNode = element['lon'];

          // Nombre del lugar si está disponible
          String placeName = 'POI sin nombre';
          if (element['tags'] != null && element['tags']['name'] != null) {
            placeName = element['tags']['name'];
          }

          markersList.add(
            Marker(
              width: 60,
              height: 60,
              point: LatLng(latNode, lonNode),
              // child en flutter_map 6.2.1 (no builder)
              child: _buildPoiMarker(placeName),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error consultando Overpass: $e');
    }

    return markersList;
  }

  // Widget que se mostrará para cada marcador
  Widget _buildPoiMarker(String placeName) {
    return GestureDetector(
      onTap: () {
        // Podemos mostrar un dialog con info del lugar
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(placeName),
            content: const Text('Más detalles del lugar...'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ],
          ),
        );
      },
      child: const Icon(
        Icons.location_on,
        size: 50,
        color: Colors.red,
      ),
    );
  }

  void _onToggleChanged() {
    // Cada vez que el usuario encienda/apague un toggle, recargamos POIs
    _fetchPOIs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa con POIs'),
      ),
      body: Stack(
        children: [
          // El mapa
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _center,
              zoom: _zoomLevel,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(markers: _markers),
            ],
          ),

          // Botones Zoom
          Positioned(
            right: 10,
            bottom: 150,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'zoomInBtn',
                  onPressed: () {
                    setState(() {
                      _zoomLevel += 1;
                      _mapController.move(_mapController.center, _zoomLevel);
                    });
                  },
                  child: const Icon(Icons.zoom_in),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: 'zoomOutBtn',
                  onPressed: () {
                    setState(() {
                      _zoomLevel -= 1;
                      _mapController.move(_mapController.center, _zoomLevel);
                    });
                  },
                  child: const Icon(Icons.zoom_out),
                ),
              ],
            ),
          ),

          // Toggles para Gimnasio y Tiendas
          Positioned(
            bottom: 20,
            left: 20,
            child: Card(
              color: Colors.white70,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: showGyms,
                          onChanged: (val) {
                            setState(() => showGyms = val ?? false);
                            _onToggleChanged();
                          },
                        ),
                        const Text('Gimnasios'),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: showStores,
                          onChanged: (val) {
                            setState(() => showStores = val ?? false);
                            _onToggleChanged();
                          },
                        ),
                        const Text('Tiendas'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
