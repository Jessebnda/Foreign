import 'package:flutter/material.dart';
import 'question_detail_screen.dart';

// Datos de ejemplo para el foro.
final List<Map<String, dynamic>> forumData = [
  {
    "title": "¿Qué lugares recomiendas para salir de noche?",
    "answers": [
      {
        "content": "Puedes ir al centro, hay varios bares y música en vivo.",
        "likes": 5,
        "comments": ["Suena interesante", "Me apunto!"]
      },
      {
        "content": "También hay eventos en la zona del malecón los fines de semana.",
        "likes": 2,
        "comments": ["Gracias por la info", "Me gusta la idea"]
      },
    ],
  },
  {
    "title": "¿Algún restaurante imperdible en Mexicali?",
    "answers": [
      {
        "content": "Yo recomiendo 'La Casa Sonora', carne asada increíble.",
        "likes": 7,
        "comments": ["¿Dónde queda?", "Amo la carne asada!"]
      }
    ],
  },
];

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final TextEditingController _questionController = TextEditingController();

  void _addQuestion() {
    final text = _questionController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      forumData.insert(0, {
        "title": text,
        "answers": [],
      });
      _questionController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Foro")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: forumData.length,
              itemBuilder: (context, index) {
                final question = forumData[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => QuestionDetailScreen(question: question),
                        transitionsBuilder: (_, animation, __, child) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage("assets/img7.jpg"),
                      ),
                      title: Text(
                        question["title"],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "${(question["answers"] as List).length} respuestas",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      trailing: const Icon(Icons.chat_bubble_outline, color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _questionController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      hintText: "Escribe tu pregunta...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addQuestion,
                  child: const Text("Publicar"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
