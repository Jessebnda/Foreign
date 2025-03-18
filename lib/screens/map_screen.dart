import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/google_places_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);
  
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  static const LatLng _center = LatLng(32.6245, -115.4523);
  final double _zoomVal = 14;
  final Set<Marker> _markers = {};

  // Instancia del servicio con tu clave API (reemplaza con la tuya)
  final GooglePlacesService placesService =
      GooglePlacesService(apiKey: 'APIKEY');

  // Lista de intereses disponibles y la selección inicial
  final List<String> availablePlaceTypes = ["gym", "store", "bar", "restaurant"];
  final List<String> selectedPlaceTypes = ["gym", "store"]; // selección inicial

  // Marcadores genéricos (siempre se muestran)
  final List<Map<String, dynamic>> defaultMarkers = [
    {
      "id": "default1",
      "name": "Lugar de Interés",
      "lat": 32.6280,
      "lng": -115.4550,
      "description": "Información general sin categoría específica."
    }
  ];
  
  @override
  void initState() {
    super.initState();
    _updateMarkers();
  }
  
  Future<void> _updateMarkers() async {
    // Limpia marcadores anteriores
    _markers.clear();
    
    // Agrega siempre los marcadores por defecto
    for (var markerData in defaultMarkers) {
      _markers.add(
        Marker(
          markerId: MarkerId(markerData["id"]),
          position: LatLng(markerData["lat"], markerData["lng"]),
          icon: BitmapDescriptor.defaultMarker,
          zIndex: 1.0,
          onTap: () {
            _showCustomInfo(
              title: markerData["name"],
              description: markerData["description"],
              location: LatLng(markerData["lat"], markerData["lng"]),
            );
          },
        ),
      );
    }
    
    // Para cada interés seleccionado, llama a fetchPlaces usando el nuevo parámetro 'query'
    for (String interest in selectedPlaceTypes) {
      await _fetchPlaces(interest);
    }
    
    setState(() {});
  }
  
  Future<void> _fetchPlaces(String query) async {
    try {
      final List results = await placesService.fetchPlaces(
        latitude: _center.latitude,
        longitude: _center.longitude,
        query: query,
      );
      
      for (var place in results) {
        final geometry = place['geometry'];
        if (geometry == null) continue;
        final location = geometry['location'];
        final lat = location['lat'];
        final lng = location['lng'];
        final name = place['name'];
        
        // Asigna colores distintos para cada interés
        double markerHue = BitmapDescriptor.hueRed;
        switch (query) {
          case 'gym':
            markerHue = BitmapDescriptor.hueMagenta;
            break;
          case 'store':
            markerHue = BitmapDescriptor.hueBlue;
            break;
          case 'bar':
            markerHue = BitmapDescriptor.hueOrange;
            break;
          case 'restaurant':
            markerHue = BitmapDescriptor.hueGreen;
            break;
        }
        
        _markers.add(
          Marker(
            markerId: MarkerId(place['place_id']),
            position: LatLng(lat, lng),
            icon: BitmapDescriptor.defaultMarkerWithHue(markerHue),
            zIndex: 2.0,
            onTap: () {
              _showCustomInfo(
                title: name,
                description: place['formatted_address'] ?? '',
                location: LatLng(lat, lng),
              );
            },
          ),
        );
      }
    } catch (e) {
      print('Error fetching places for query "$query": $e');
    }
  }
  
  void _showCustomInfo({
    required String title,
    required String description,
    required LatLng location,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(description),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.map),
                label: const Text('Ver en Google Maps'),
                onPressed: () {
                  _openGoogleMaps(location);
                },
              ),
            ],
          ),
        );
      },
    );
  }
  
  Future<void> _openGoogleMaps(LatLng location) async {
    final googleUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}');
    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir Google Maps')),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Lugares'),
      ),
      body: Column(
        children: [
          // Sección de selección de intereses con FilterChips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8),
            child: Row(
              children: availablePlaceTypes.map((type) {
                final isSelected = selectedPlaceTypes.contains(type);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(type.toUpperCase()),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedPlaceTypes.add(type);
                        } else {
                          selectedPlaceTypes.remove(type);
                        }
                        // Actualiza los marcadores según la nueva selección
                        _updateMarkers();
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          // Mapa
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) => _mapController = controller,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: _zoomVal,
              ),
              markers: _markers,
              mapType: MapType.normal,
            ),
          ),
        ],
      ),
    );
  }
}
