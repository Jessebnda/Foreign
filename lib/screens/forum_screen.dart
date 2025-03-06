import 'package:flutter/material.dart';
import 'question_detail_screen.dart';

// Datos de ejemplo para el foro.
final List<Map<String, dynamic>> forumData = [
  {
    "title": "¿Qué lugares recomiendas para salir de noche?",
    "answers": [
      {
        "content": "Puedes ir al centro, hay varios bares y música en vivo.",
        "comments": ["Suena interesante", "Me apunto!"]
      },
      {
        "content": "También hay eventos en la zona del malecón los fines de semana.",
        "comments": ["Gracias por la info", "Me gusta la idea"]
      },
    ],
  },
  {
    "title": "¿Algún restaurante imperdible en Mexicali?",
    "answers": [
      {
        "content": "Yo recomiendo 'La Casa Sonora', carne asada increíble.",
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
      appBar: AppBar(
        title: const Text("Foro"),
      ),
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
                      MaterialPageRoute(
                        builder: (_) => QuestionDetailScreen(question: question),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(question["title"]),
                      subtitle: Text(
                        "${(question["answers"] as List).length} respuestas",
                      ),
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
                    decoration: const InputDecoration(
                      hintText: "Escribe tu pregunta...",
                      border: OutlineInputBorder(),
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
