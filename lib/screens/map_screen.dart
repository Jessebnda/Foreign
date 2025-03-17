import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  GoogleMapController? _mapController;
  static const LatLng _center = LatLng(32.6245, -115.4523);
  final double _zoomVal = 14;
  bool showGyms = false;
  bool showStores = false;
  final Set<Marker> _markers = {};

  // Datos estáticos para los marcadores de gimnasios
  final List<Map<String, dynamic>> gymMarkers = [
    {
      "id": "gym1",
      "name": "Gym Fitness Center",
      "lat": 32.6245,
      "lng": -115.4523,
      "description":
          "Este gimnasio cuenta con excelentes instalaciones y equipo de última generación."
    }
  ];

  // Datos estáticos para los marcadores de mercados
  final List<Map<String, dynamic>> marketMarkers = [
    {
      "id": "market1",
      "name": "Mercado Local",
      "lat": 32.6300,
      "lng": -115.4500,
      "description": "Un mercado con productos frescos y locales."
    }
  ];

  // Marcadores genéricos (siempre se muestran)
  final List<Map<String, dynamic>> defaultMarkers = [
    {
      "id": "default1",
      "name": "Lugar de Interés",
      "lat": 32.6280,
      "lng": -115.4550,
      "description":
          "Información general del lugar sin categoría específica."
    }
  ];

  @override
  void initState() {
    super.initState();
    _updateMarkers();
  }

  void _updateMarkers() {
    _markers.clear();

    // Agrega marcadores de gimnasios si están activados
    if (showGyms) {
      for (var markerData in gymMarkers) {
        _markers.add(
          Marker(
            markerId: MarkerId(markerData["id"]),
            position: LatLng(markerData["lat"], markerData["lng"]),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueMagenta),
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
    }

    // Agrega marcadores de mercados si están activados
    if (showStores) {
      for (var markerData in marketMarkers) {
        _markers.add(
          Marker(
            markerId: MarkerId(markerData["id"]),
            position: LatLng(markerData["lat"], markerData["lng"]),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueBlue),
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
    }

    // Agrega siempre los marcadores genéricos
    for (var markerData in defaultMarkers) {
      _markers.add(
        Marker(
          markerId: MarkerId(markerData["id"]),
          position: LatLng(markerData["lat"], markerData["lng"]),
          icon: BitmapDescriptor.defaultMarker,
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

    setState(() {});
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
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
      appBar: AppBar(title: const Text('Mapa de Lugares')),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => _mapController = controller,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: _zoomVal,
            ),
            markers: _markers,
            mapType: MapType.normal,
          ),
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
                            setState(() {
                              showGyms = val ?? false;
                              _updateMarkers();
                            });
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
                            setState(() {
                              showStores = val ?? false;
                              _updateMarkers();
                            });
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
