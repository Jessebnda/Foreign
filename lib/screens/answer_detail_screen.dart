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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.answer["content"],
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const Divider(),
          const Text(
            "Comentarios:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return ListTile(
                  title: Text(comment),
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
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
