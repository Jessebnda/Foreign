import 'package:dio/dio.dart';

Future<String> fetchChatbotAnswer(Map<String, String> params) async {
  final String question = params['question']!;
  final String chatbotUrl = params['chatbotUrl']!;
  try {
    final response = await Dio().get(chatbotUrl, queryParameters: {"question": question});
    return response.data['result'] ?? 'No se obtuvo respuesta.';
  } catch (e) {
    return 'Error al comunicarse con el chatbot.';
  }
}
