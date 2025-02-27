import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({Key? key}) : super(key: key);
  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  GoogleMapController? _mapController;
  static const LatLng _center = LatLng(32.6245, -115.4523);
  double _zoomVal = 14;
  bool showGyms = false;
  bool showStores = false;
  final Set<Marker> _markers = {};
  final String _googleApiKey = 'TU_API_KEY';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Maps')),
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
                              _updatePlaces();
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
                              _updatePlaces();
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
  
  Future<void> _updatePlaces() async {
    setState(() => _markers.clear());
    if (showGyms) {
      await _textSearch("One Premium", colorHue: BitmapDescriptor.hueMagenta);
      await _textSearch("Family Fitness", colorHue: BitmapDescriptor.hueMagenta);
      await _textSearch("Ultra Gym", colorHue: BitmapDescriptor.hueMagenta);
      await _textSearch("Evolution Gym", colorHue: BitmapDescriptor.hueMagenta);
    }
    if (showStores) {
      await _textSearch("Walmart", colorHue: BitmapDescriptor.hueBlue);
      await _textSearch("Calimax", colorHue: BitmapDescriptor.hueBlue);
      await _textSearch("Costco", colorHue: BitmapDescriptor.hueBlue);
      await _textSearch("Oxxo", colorHue: BitmapDescriptor.hueBlue);
    }
  }
  
  Future<void> _textSearch(String query, {double colorHue = BitmapDescriptor.hueRed}) async {
    final lat = _center.latitude;
    final lng = _center.longitude;
    const radius = 5000;
    final url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json'
        '?query=$query'
        '&location=$lat,$lng'
        '&radius=$radius'
        '&key=$_googleApiKey';
    try {
      final response = await Dio().get(url);
      final data = response.data;
      if (data['status'] == 'OK') {
        for (var result in data['results']) {
          final placeLat = result['geometry']['location']['lat'];
          final placeLng = result['geometry']['location']['lng'];
          final name = result['name'] ?? 'Lugar sin nombre';
          _markers.add(
            Marker(
              markerId: MarkerId('$name-$placeLat-$placeLng'),
              position: LatLng(placeLat, placeLng),
              infoWindow: InfoWindow(title: name),
              icon: BitmapDescriptor.defaultMarkerWithHue(colorHue),
            ),
          );
        }
        setState(() {});
      } else {
        debugPrint('Google Places: status = ${data['status']}');
      }
    } catch (e) {
      debugPrint('Error en textSearch: $e');
    }
  }
}
