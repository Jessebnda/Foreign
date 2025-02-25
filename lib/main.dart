import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(const SocialApp());
}

// App principal
class SocialApp extends StatelessWidget {
  const SocialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.purple[800],
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.purple[800],
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.purple[800],
          foregroundColor: Colors.white,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

// Barra de navegación con Feed, Mapa, Foro, Mentor, Perfil
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const FeedScreen(),         // Feed primero
    const GoogleMapScreen(),    // Mapa Google
    const PlaceholderScreen(title: 'Foro'),
    const PlaceholderScreen(title: 'Mentor'),
    const PlaceholderScreen(title: 'Perfil'),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Mapa'),
          BottomNavigationBarItem(icon: Icon(Icons.forum), label: 'Foro'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Mentor'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

// FeedScreen (igual que siempre)
class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foreign'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(10),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.purple,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Usuario $index',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.purple[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Icon(Icons.image, size: 50, color: Colors.purple),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Este es un post de ejemplo en la red social.',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Placeholder para Foro, Mentor, Perfil
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title en construcción')),
    );
  }
}

// GoogleMapScreen con toggles para “Tiendas” y “Gimnasios”
class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  GoogleMapController? _mapController;

  // Centro (Mexicali) en la cámara inicial
  static const LatLng _center = LatLng(32.6245, -115.4523);
  double _zoomVal = 14;

  // Toggles
  bool showGyms = false;
  bool showStores = false;

  // Marcadores
  final Set<Marker> _markers = {};

  // Tu API Key (Places). Debe ser la misma si la habilitaste para Maps + Places
  final String _googleApiKey = 'TU_API_KEY';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Map con Places'),
      ),
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            onMapCreated: (controller) => _mapController = controller,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: _zoomVal,
            ),
            markers: _markers,
            mapType: MapType.normal,
          ),

          // Botones Zoom
          Positioned(
            right: 10,
            bottom: 150,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'zoomInBtn',
                  onPressed: _zoomIn,
                  child: const Icon(Icons.zoom_in),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: 'zoomOutBtn',
                  onPressed: _zoomOut,
                  child: const Icon(Icons.zoom_out),
                ),
              ],
            ),
          ),

          // Toggles
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
                            _updatePlaces();
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
                            _updatePlaces();
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

  void _zoomIn() {
    setState(() => _zoomVal++);
    _mapController?.moveCamera(CameraUpdate.zoomTo(_zoomVal));
  }

  void _zoomOut() {
    setState(() => _zoomVal--);
    _mapController?.moveCamera(CameraUpdate.zoomTo(_zoomVal));
  }

  /// Llamamos a la Places API para buscar “gimnasios” o “tiendas”
  Future<void> _updatePlaces() async {
    // Limpia marcadores actuales
    setState(() => _markers.clear());

    // 1) Gimnasios
    if (showGyms) {
      // Buscamos “One Premium, Family Fitness, Ultra, Evolution” cerca
      await _textSearch("One Premium", colorHue: BitmapDescriptor.hueMagenta);
      await _textSearch("Family Fitness", colorHue: BitmapDescriptor.hueMagenta);
      await _textSearch("Ultra Gym", colorHue: BitmapDescriptor.hueMagenta);
      await _textSearch("Evolution Gym", colorHue: BitmapDescriptor.hueMagenta);

      // O en vez de 4 llamadas, podrías buscar “gym near me”
      // pero luego filtrar con brand/nombre manualmente
    }

    // 2) Tiendas
    if (showStores) {
      // Buscamos walmart, calimax, costco, oxxo
      await _textSearch("Walmart", colorHue: BitmapDescriptor.hueBlue);
      await _textSearch("Calimax", colorHue: BitmapDescriptor.hueBlue);
      await _textSearch("Costco", colorHue: BitmapDescriptor.hueBlue);
      await _textSearch("Oxxo", colorHue: BitmapDescriptor.hueBlue);
    }
  }

  /// Llama a la Places API con un “Text Search”
  /// Endpoint: https://maps.googleapis.com/maps/api/place/textsearch/json
  /// Combinará la query con la ubicación central
  Future<void> _textSearch(String query, {double colorHue = BitmapDescriptor.hueRed}) async {
    final lat = _center.latitude;
    final lng = _center.longitude;
    const radius = 5000; // 5km

    final url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json'
        '?query=$query'
        '&location=$lat,$lng'
        '&radius=$radius'
        '&key=$_googleApiKey';

    try {
      final response = await Dio().get(url);
      final data = response.data;

      // Revisa “status” de la respuesta
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

        // Actualizar UI
        setState(() {});
      } else {
        // Ej. si status=ZERO_RESULTS
        debugPrint('Google Places: status = ${data['status']}');
      }
    } catch (e) {
      debugPrint('Error en textSearch: $e');
    }
  }
}
