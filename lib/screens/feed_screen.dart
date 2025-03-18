import 'package:flutter/material.dart';
import 'publication_detail_screen.dart';

// Datos de ejemplo para publicaciones
final List<Map<String, dynamic>> postsData = [
  {"user": "Alice", "content": "Evento deportivo del fin de semana."},
  {"user": "Bob", "content": "Concierto en vivo en el centro."},
  {"user": "Carol", "content": "Feria gastronómica en Mexicali."},
  {"user": "Dave", "content": "Exhibición de arte urbano."},
  {"user": "Eve", "content": "Competencia de skate."},
  {"user": "Frank", "content": "Show de comedia local."},
];

// Datos para Weekly events (pueden ser los mismos o diferentes)
final List<Map<String, dynamic>> weeklyEvents = [
  {"user": "Alice", "content": "Evento deportivo del fin de semana."},
  {"user": "Bob", "content": "Concierto en vivo en el centro."},
  {"user": "Carol", "content": "Feria gastronómica en Mexicali."},
];

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  /// Construye el slider de "Weekly events"
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
            itemCount: weeklyEvents.length,
            itemBuilder: (context, index) {
              final event = weeklyEvents[index];
              return Container(
                margin: const EdgeInsets.only(right: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PublicationDetailScreen(
                          post: event,
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
                            backgroundImage: AssetImage('assets/images/img7.jpg'),
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

  /// Construye un grid de publicaciones a partir de la lista de posts
  Widget _buildMainFeedGrid(BuildContext context, List<Map<String, dynamic>> posts) {
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: posts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Dos columnas
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.4,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final post = posts[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PublicationDetailScreen(
                  post: post,
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
                    backgroundImage: AssetImage('assets/images/img7.jpg'),
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
    return DefaultTabController(
      length: 2, // "Your Feed" y "Friends"
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Foreign'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Your Feed'),
              Tab(text: 'Friends'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Pestaña "Your Feed": Slider de Weekly events + grid
            SingleChildScrollView(
              child: Column(
                children: [
                  _buildWeeklyEventsSlider(context),
                  const SizedBox(height: 20),
                  _buildMainFeedGrid(context, postsData),
                ],
              ),
            ),
            // Pestaña "Friends": Solo grid de publicaciones
            _buildMainFeedGrid(context, postsData),
          ],
        ),
      ),
    );
  }
}
