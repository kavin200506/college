import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:college/features/ai_mentor/data/ai_client.dart';
 // for Message model

final deepSeekClientProvider = Provider<AIClient>((ref) {
  return DeepSeekClient(
    baseUrl: const String.fromEnvironment(
      'DEEPSEEK_ENDPOINT',
      defaultValue: 'http://192.168.1.12', // replace with your server IP
    ),
  );
});

class DeepSeekClient implements AIClient {
  DeepSeekClient({required this.baseUrl});
  final String baseUrl;

  @override
  Future<String> chat(List<Message> history) async {
    final body = jsonEncode({
      "messages": history
          .map((m) => {"role": m.role, "content": m.content})
          .toList(),
      "thinking": false,
      "max_tokens": 256,
      "temperature": 0.8,
    });

    final res = await http.post(
      Uri.parse("$baseUrl/chat"),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body)["reply"];
    } else {
      throw Exception("DeepSeek error ${res.statusCode}: ${res.body}");
    }
  }
}
