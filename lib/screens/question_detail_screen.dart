import 'package:flutter/material.dart';
import 'answer_detail_screen.dart';

class QuestionDetailScreen extends StatefulWidget {
  final Map<String, dynamic> question;
  const QuestionDetailScreen({super.key, required this.question});

  @override
  State<QuestionDetailScreen> createState() => _QuestionDetailScreenState();
}

class _QuestionDetailScreenState extends State<QuestionDetailScreen> {
  final TextEditingController _answerController = TextEditingController();

  void _addAnswer() {
    final text = _answerController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      (widget.question["answers"] as List).insert(0, {
        "content": text,
        "likes": 0,
        "comments": []
      });
      _answerController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final answers = widget.question["answers"] as List;
    return Scaffold(
      appBar: AppBar(title: Text(widget.question["title"])),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: answers.length,
              itemBuilder: (context, index) {
                final answer = answers[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AnswerDetailScreen(answer: answer)),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage("assets/img7.jpg"),
                      ),
                      title: Text(answer["content"]),
                      subtitle: Text("${(answer["comments"] as List).length} comentarios"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.favorite_border),
                            onPressed: () {
                              setState(() {
                                answer["likes"]++;
                              });
                            },
                          ),
                          Text("${answer["likes"]}"),
                        ],
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
                    controller: _answerController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      hintText: "Escribe tu respuesta...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addAnswer,
                  child: const Text("Responder"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
