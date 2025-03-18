import 'package:flutter/material.dart';

class AnswerDetailScreen extends StatefulWidget {
  final Map<String, dynamic> answer;
  const AnswerDetailScreen({super.key, required this.answer});

  @override
  State<AnswerDetailScreen> createState() => _AnswerDetailScreenState();
}

class _AnswerDetailScreenState extends State<AnswerDetailScreen> {
  final TextEditingController _commentController = TextEditingController();

  void _addComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      (widget.answer["comments"] as List).add(text);
      _commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final comments = widget.answer["comments"] as List;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalles de la Respuesta"),
      ),
      body: Column(
        children: [
          // Contenido de la respuesta
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.answer["content"],
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const Divider(),
          // Sección de comentarios
          Text(
            "Comentarios:",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        comment,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Campo para agregar un nuevo comentario
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: "Escribe un comentario...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addComment,
                  child: const Text("Comentar"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
