import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ai_client.dart';
import '../../../core/models/message.dart';

class OllamaClient implements AIClient {
  final String baseUrl;
  final String model;

  // Remove 'const' - HTTP operations can't be const
  OllamaClient({
    required this.baseUrl,
    required this.model,
  });

  @override
  Future<String> sendMessage(String message) async {
    return chat([Message('user', message)]);
  }

  @override
  Future<String> chat(List<Message> history) async {
    try {
      // Send full chat history for better context
      final lastMessage = history.isNotEmpty ? history.last.content : '';
      
      print('🔄 Sending request to: $baseUrl/api/generate');
      print('📝 Model: $model');
      print('💬 Prompt: $lastMessage');
      
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/generate'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'model': model,
              'prompt': lastMessage,
              'stream': false,
              'keep_alive': -1,  // ← Keep model loaded
            }),
          )
          .timeout(const Duration(seconds: 30)); // ← Add timeout

      print('📊 Response status: ${response.statusCode}');
      print('📄 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        
        // Handle different possible response formats
        if (jsonResponse['response'] != null) {
          return jsonResponse['response'].toString().trim();
        } else if (jsonResponse['content'] != null) {
          return jsonResponse['content'].toString().trim();
        } else if (jsonResponse['choices'] != null && jsonResponse['choices'].isNotEmpty) {
          return jsonResponse['choices'][0]['message']['content'].toString().trim();
        } else {
          print('⚠️ Unexpected response format: $jsonResponse');
          return 'No valid response from AI server';
        }
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } on http.ClientException catch (e) {
      print('❌ Network error: $e');
      throw Exception('Network connection failed: $e');
    } on FormatException catch (e) {
      print('❌ JSON parsing error: $e');
      throw Exception('Invalid response format: $e');
    } catch (e) {
      print('❌ General error: $e');
      throw Exception('Error connecting to AI server: $e');
    }
  }
}
