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

  // Marcadores obtenidos de la API (y manuales que no son favoritos)
  final Set<Marker> _markers = {};
  // Marcadores marcados como favoritos (manuales o de API que se agreguen como favoritos)
  final Set<Marker> _favoriteMarkers = {};

  // Variable para activar el modo "agregar manualmente"
  bool _isAddingPlace = false;

  // Instancia del servicio con tu clave API (reemplaza "APIKEY" o usa dotenv en tu código Dart)
  final GooglePlacesService placesService =
      GooglePlacesService(apiKey: 'APIKEY');

  // Lista de categorías disponibles, agregando "favoritos"
  final List<String> availablePlaceTypes = ["gym", "store", "bar", "restaurant", "favoritos"];
  // Lista de filtros seleccionados. Si "favoritos" está incluido, se muestran solo los favoritos.
  final List<String> selectedPlaceTypes = [];

  // Lista de marcadores por defecto (opcional)
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
  
  /// Actualiza los marcadores consultando la API para cada categoría seleccionada (excepto "favoritos")
  Future<void> _updateMarkers() async {
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
              markerId: markerData["id"],
            );
          },
        ),
      );
    }
    
    // Para cada categoría seleccionada, si no es "favoritos", llama a la API
    for (String interest in selectedPlaceTypes) {
      if (interest.toLowerCase() == "favoritos") continue;
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
        final markerIdValue = place['place_id'] ?? "manual_${lat}_${lng}";
        
        // Asigna un color distinto según la categoría
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
            markerId: MarkerId(markerIdValue),
            position: LatLng(lat, lng),
            icon: BitmapDescriptor.defaultMarkerWithHue(markerHue),
            zIndex: 2.0,
            onTap: () {
              _showCustomInfo(
                title: name,
                description: place['formatted_address'] ?? '',
                location: LatLng(lat, lng),
                markerId: markerIdValue,
              );
            },
          ),
        );
      }
    } catch (e) {
      print('Error fetching places for query "$query": $e');
    }
  }

  /// Muestra un modal con la información del marcador y opción para marcar/quitar como favorito.
  void _showCustomInfo({
    required String title,
    required String description,
    required LatLng location,
    String? markerId,
  }) {
    // Determina si el marcador ya es favorito
    bool isFavorite = markerId != null &&
        _favoriteMarkers.any((m) => m.markerId.value == markerId);

    showModalBottomSheet(
      context: context,
      builder: (context) {
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
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.map),
                    label: const Text('Ver en Google Maps'),
                    onPressed: () {
                      _openGoogleMaps(location);
                    },
                  ),
                  const SizedBox(width: 16),
                  if (markerId != null)
                    ElevatedButton.icon(
                      icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                      label: Text(isFavorite ? "Quitar Favorito" : "Marcar como Favorito"),
                      onPressed: () {
                        setState(() {
                          if (isFavorite) {
                            _favoriteMarkers.removeWhere((m) => m.markerId.value == markerId);
                          } else {
                            final favMarker = Marker(
                              markerId: MarkerId(markerId),
                              position: location,
                              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
                              infoWindow: InfoWindow(title: "Favorito: $title"),
                            );
                            _favoriteMarkers.add(favMarker);
                          }
                        });
                        Navigator.pop(context);
                      },
                    ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _openGoogleMaps(LatLng location) async {
    final googleUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}'
    );
    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir Google Maps')),
      );
    }
  }

  /// Modo manual: al hacer long press se solicita agregar un marcador manualmente.
  void _handleLongPress(LatLng position) {
    // Solo se activa si el usuario presionó el botón para agregar lugar.
    if (_isAddingPlace) {
      final TextEditingController _placeNameController = TextEditingController();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Agregar Lugar Favorito"),
            content: TextField(
              controller: _placeNameController,
              decoration: const InputDecoration(labelText: "Nombre del lugar"),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _isAddingPlace = false;
                  });
                },
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () {
                  final placeName = _placeNameController.text.trim();
                  if (placeName.isNotEmpty) {
                    final markerIdValue = "manual_${DateTime.now().millisecondsSinceEpoch}";
                    final manualMarker = Marker(
                      markerId: MarkerId(markerIdValue),
                      position: position,
                      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
                      zIndex: 2.0,
                      onTap: () {
                        _showCustomInfo(
                          title: placeName,
                          description: "Lugar agregado manualmente",
                          location: position,
                          markerId: markerIdValue,
                        );
                      },
                    );
                    setState(() {
                      _favoriteMarkers.add(manualMarker);
                      // También agregamos al conjunto general si deseamos que se vea en el mapa
                      _markers.add(manualMarker);
                      _isAddingPlace = false;
                    });
                  }
                  Navigator.pop(context);
                },
                child: const Text("Guardar"),
              )
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determina los marcadores a mostrar:
    // Si el chip "favoritos" está seleccionado, muestra solo los favoritos; de lo contrario, muestra los marcadores de API y manuales.
    final bool showOnlyFavorites = selectedPlaceTypes.contains("favoritos");
    final Set<Marker> markersToShow = showOnlyFavorites ? _favoriteMarkers : _markers;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Lugares'),
      ),
      body: Column(
        children: [
          // Fila de FilterChips: muestra las categorías disponibles, incluyendo "favoritos"
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
                        _updateMarkers();
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          // Muestra el mapa con los marcadores filtrados
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) => _mapController = controller,
              onLongPress: _handleLongPress,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: _zoomVal,
              ),
              markers: markersToShow,
              mapType: MapType.normal,
            ),
          ),
          // Botón flotante para activar el modo "agregar lugar manual"
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text("Agregar Lugar Manual"),
              onPressed: () {
                setState(() {
                  _isAddingPlace = true;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Modo agregar lugar activado. Long press en el mapa para seleccionar un lugar."),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
