import 'package:flutter/material.dart';
import 'mentor_chat_screen.dart';

final List<Map<String, String>> mentorsData = [
  {
    "name": "Juan Pérez",
    "area": "Deportes",
  },
  {
    "name": "María López",
    "area": "Asuntos Legales",
  },
  {
    "name": "Carlos García",
    "area": "Tecnología",
  },
];

class MentorListScreen extends StatelessWidget {
  const MentorListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: ListView.builder(
        itemCount: mentorsData.length,
        itemBuilder: (context, index) {
          final mentor = mentorsData[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/img7.jpg'),
              ),
              title: Text(mentor["name"]!),
              subtitle: Text("Área: ${mentor["area"]}"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MentorChatScreen(mentor: mentor),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
