import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';
import '../services/api_service.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});
  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  final String _chatbotUrl =
      'https://magicloops.dev/api/loop/MagicLoops_API_KEY/run';

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isLoading = true;
    });
    _controller.clear();
    try {
      final answer = await compute(fetchChatbotAnswer, {
        "question": text,
        "chatbotUrl": _chatbotUrl,
      });
      setState(() {
        _messages.add(ChatMessage(text: answer, isUser: false));
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
            text: 'Error al comunicarse con el chatbot.', isUser: false));
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              return Container(
                alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: message.isUser ? Colors.purple[200] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(message.text),
                ),
              );
            },
          ),
        ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Escribe tu pregunta...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _isLoading ? null : _sendMessage,
                child: const Text('Enviar'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
