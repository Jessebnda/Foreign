import 'package:flutter/material.dart';

class PublicationDetailScreen extends StatelessWidget {
  final Map<String, dynamic> post;
  final String imagePath;

  const PublicationDetailScreen({
    super.key,
    required this.post,
    required this.imagePath,
  });

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
            // Imagen principal
            Image.asset(
              imagePath,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            // Sección de contenido
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info del usuario
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            AssetImage('assets/images/img7.jpg'),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        post["user"] ?? "",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Contenido de la publicación
                  Text(
                    post["content"] ?? "",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),
                  const Text(
                    "Comentarios:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Lista de comentarios de prueba
                  ...testComments.map(
                    (comment) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(comment),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
