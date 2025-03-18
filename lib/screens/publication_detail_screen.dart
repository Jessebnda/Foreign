import 'package:flutter/material.dart';

class PublicationDetailScreen extends StatelessWidget {
  final Map<String, dynamic> post;
  final String imagePath;

  const PublicationDetailScreen({
    Key? key,
    required this.post,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lista de comentarios de ejemplo (sustitúyela por tus datos reales)
    final List<String> testComments = [
      "Comentario prueba 1",
      "Comentario prueba 2",
      "Comentario prueba 3",
    ];

    final textTheme = Theme.of(context).textTheme;

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
              height: 300,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            // Contenido principal de la publicación
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Información del usuario: avatar y nombre
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage('assets/images/img7.jpg'),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        post["user"] ?? "",
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Contenido de la publicación
                  Text(
                    post["content"] ?? "",
                    style: textTheme.bodyLarge?.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),
                  Text(
                    "Comentarios:",
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Lista de comentarios en Cards
                  ...testComments.map(
                    (comment) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 0),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 18,
                                backgroundImage:
                                    AssetImage('assets/images/img7.jpg'),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  comment,
                                  style: textTheme.bodyLarge?.copyWith(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
