import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Datos del perfil
  String name = "Jesse Banda";
  String origin = "Mexicali";
  List<String> interests = ["gimnasio", "programación", "deportes"];
  
  // Publicaciones (lista de rutas de imagen)
  List<String> publications = [
    'assets/images/img1.jpg',
    'assets/images/img2.jpg',
    'assets/images/img3.jpg',
    'assets/images/img4.jpg',
    'assets/images/img5.jpg',
    'assets/images/img6.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Aquí iría la navegación a la pantalla de edición
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Información del perfil
          Row(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: const AssetImage('assets/images/img7.jpg'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16),
                        const SizedBox(width: 4),
                        Text(origin),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: interests.map((tag) => Chip(label: Text(tag))).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            "Publicaciones",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Grid de publicaciones del perfil
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: publications.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              final imagePath = publications[index];
              return InkWell(
                onTap: () {
                  // Al tocar una publicación se navega al detalle, enviando datos de ejemplo
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PublicationDetailScreen(
                        post: {
                          "user": name,
                          "content": "Esta es una publicación en mi perfil.",
                        },
                        imagePath: imagePath,
                      ),
                    ),
                  );
                },
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Ejemplo: agregar una nueva publicación
          setState(() {
            publications.add('assets/images/img1.jpg');
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Pantalla de detalle de la publicación (usada tanto en Feed como en Perfil)
class PublicationDetailScreen extends StatelessWidget {
  final Map<String, dynamic> post;
  final String imagePath;
  
  const PublicationDetailScreen({Key? key, required this.post, required this.imagePath}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Comentarios de prueba
    final List<String> testComments = [
      "Comentario prueba 1",
      "Comentario prueba 2",
      "Comentario prueba 3",
    ];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle de la Publicación"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen de la publicación
            Image.asset(
              imagePath,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            // Detalles de la publicación
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Información del usuario (foto de perfil y nombre)
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage('assets/images/img7.jpg'),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        post["user"],
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Contenido o título de la publicación
                  Text(
                    post["content"],
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),
                  const Text(
                    "Comentarios:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  // Listado de comentarios de prueba
                  ...testComments.map((comment) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(comment),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
