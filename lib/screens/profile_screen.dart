import 'package:flutter/material.dart';
import 'publication_detail_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Datos del perfil
  String name = "Jesse Banda";
  String origin = "Mexicali";
  List<String> interests = ["gimnasio", "programación", "deportes"];
  String profileImage = 'assets/images/img7.jpg';
  
  // Publicaciones (lista de rutas de imagen)
  List<String> publications = [
    'assets/images/img1.jpg',
    'assets/images/img2.jpg',
    'assets/images/img3.jpg',
    'assets/images/img4.jpg',
    'assets/images/img5.jpg',
    'assets/images/img6.jpg',
  ];

  void _editProfile() async {
    // Usa showModalBottomSheet para presentar la pantalla de edición como modal de pantalla completa.
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true, // Para permitir modal de pantalla completa
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.95, // Ajusta el porcentaje de la pantalla
        child: EditProfileScreen(
          currentName: name,
          currentOrigin: origin,
          currentInterests: interests,
          currentProfileImage: profileImage,
        ),
      ),
    );
    
    // Si se retornen datos, actualiza el estado del perfil
    if (result != null) {
      setState(() {
        name = result['name'] as String;
        origin = result['origin'] as String;
        interests = List<String>.from(result['interests'] as List);
        profileImage = result['profileImage'] as String;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editProfile,
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
                backgroundImage: AssetImage(profileImage),
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
