import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ai_client.dart';
import '../../../core/models/message.dart';  // Import shared Message only

class OllamaClient implements AIClient {
  final String baseUrl;
  final String model;

  const OllamaClient({
    required this.baseUrl,
    required this.model,
  });

  @override
  Future<String> sendMessage(String message) async {
    // Convert single message to chat format
    return chat([Message('user', message)]);
  }

  @override
  Future<String> chat(List<Message> history) async {
    try {
      // Use the last message for simple implementation
      final lastMessage = history.isNotEmpty ? history.last.content : '';
      
      final response = await http.post(
        Uri.parse('$baseUrl/api/generate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'model': model,
          'prompt': lastMessage,
          'stream': false,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['response'] ?? 'No response from AI';
      } else {
        throw Exception('Failed to get AI response: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to AI: $e');
    }
  }
}
