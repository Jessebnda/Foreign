import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: "apis.env");
  runApp(const SocialApp());
}
// Función actualizada para llamar a Magic Loops API
Future<String> fetchChatbotAnswer(Map<String, String> params) async {
  final String question = params['question']!;
  // URL de Magic Loops (la que has compartido)
  final String chatbotUrl = "https://magicloops.dev/api/loop/${dotenv.env['MAGIC_LOOPS_API_KEY']}/run";

  try {
    // Usamos GET y enviamos la pregunta en los queryParameters
    final response = await Dio().get(chatbotUrl, queryParameters: {"question": question});
    return response.data['result'] ?? 'No se obtuvo respuesta.';
  } catch (e) {
    return 'Error al comunicarse con el chatbot.';
  }
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
        scaffoldBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
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
    const MentorScreen(),       // Mentor y Chatbot
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

// Placeholder para Foro y Perfil
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

// GoogleMapScreen (no modificado en este ejemplo)
class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});
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
      appBar: AppBar(title: const Text('Google Map con Places')),
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
            right: 10,
            bottom: 150,
            child: Column(
              children: [
               
                const SizedBox(height: 10),
                
              ],
            ),
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

// MentorScreen: con dos pestañas: Mentor y Chatbot
class MentorScreen extends StatelessWidget {
  const MentorScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mentor'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Mentor'),
              Tab(text: 'Chatbot'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MentorPlaceholder(),
            ChatbotScreen(),
          ],
        ),
      ),
    );
  }
}

// MentorPlaceholder
class MentorPlaceholder extends StatelessWidget {
  const MentorPlaceholder({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Sección Mentor en construcción'),
    );
  }
}

// ChatbotScreen: usa Magic Loops API en lugar de nuestro endpoint local
class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});
  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}
class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  // URL de Magic Loops API
  final String _chatbotUrl = 'https://magicloops.dev/api/loop/624ec5d5-053b-4ad4-a4fe-0b00bddc2a50/run';
  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isLoading = true;
    });
    _controller.clear();
    try {
      // Se usa GET con queryParameters para Magic Loops API
      final answer = await compute(fetchChatbotAnswer, {
        "question": text,
        "chatbotUrl": _chatbotUrl,
      });
      setState(() {
        _messages.add(ChatMessage(text: answer, isUser: false));
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(text: 'Error al comunicarse con el chatbot.', isUser: false));
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              return Container(
                alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: message.isUser ? Colors.purple[200] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(message.text),
                ),
              );
            },
          ),
        ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Escribe tu pregunta...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _isLoading ? null : _sendMessage,
                child: const Text('Enviar'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}
