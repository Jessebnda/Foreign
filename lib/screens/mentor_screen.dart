// lib/screens/mentor/mentor_screen.dart

import 'package:flutter/material.dart';
import 'mentor_list_screen.dart';     // <-- Lista de mentores
// <-- Si prefieres un chat local con mentores
import 'chatbot_screen.dart';        // <-- Si tu Chatbot es distinto, usa tu import real

class MentorScreen extends StatelessWidget {
  const MentorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Dos pestañas: Mentores y Chatbot
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mentor'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Mentores'),
              Tab(text: 'Chatbot'),
            ],
          ),
        ),
        // TabBarView con MentorListScreen y ChatbotScreen
        body: const TabBarView(
          children: [
            MentorListScreen(), // Lista de mentores (foto, nombre, área)
            ChatbotScreen(),    // Pantalla del Chatbot (Magic Loops u otro)
          ],
        ),
      ),
    );
  }
}
