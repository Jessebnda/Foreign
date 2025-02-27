import 'package:flutter/material.dart';
import 'publication_detail_screen.dart';

// Datos de ejemplo (cada post tiene "user" y "content")
final List<Map<String, dynamic>> postsData = [
  {"user": "Alice", "content": "Evento deportivo del fin de semana."},
  {"user": "Bob", "content": "Concierto en vivo en el centro."},
  {"user": "Carol", "content": "Feria gastronómica en Mexicali."},
  {"user": "Dave", "content": "Exhibición de arte urbano."},
  {"user": "Eve", "content": "Competencia de skate."},
  {"user": "Frank", "content": "Show de comedia local."},
];

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  bool _imagesPrecached = false;

  // Para evitar el error de dependOnInheritedWidget en initState,
  // usamos didChangeDependencies() para precargar imágenes.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_imagesPrecached) {
      for (int i = 1; i <= postsData.length; i++) {
        precacheImage(AssetImage('assets/images/img$i.jpg'), context);
      }
      precacheImage(const AssetImage('assets/images/img7.jpg'), context);
      _imagesPrecached = true;
    }
  }

  // Slider de "Weekly events" (mostrando 1 post a la vez con PageView)
  Widget _buildWeeklyEventsSlider(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Weekly events",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: PageController(viewportFraction: 1.0, initialPage: 0),
            itemCount: postsData.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(right: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PublicationDetailScreen(
                          post: postsData[index],
                          imagePath: 'assets/images/img${index + 1}.jpg',
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            'assets/images/img${index + 1}.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                        const Positioned(
                          bottom: 8,
                          right: 8,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                AssetImage('assets/images/img7.jpg'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Grid principal de publicaciones
  Widget _buildMainFeedGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: postsData.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Dos columnas
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.4,
      ),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PublicationDetailScreen(
                  post: postsData[index],
                  imagePath: 'assets/images/img${index + 1}.jpg',
                ),
              ),
            );
          },
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/img${index + 1}.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                const Positioned(
                  bottom: 8,
                  right: 8,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        AssetImage('assets/images/img7.jpg'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feed"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _buildWeeklyEventsSlider(context),
            const SizedBox(height: 20),
            _buildMainFeedGrid(context),
          ],
        ),
      ),
    );
  }
}
