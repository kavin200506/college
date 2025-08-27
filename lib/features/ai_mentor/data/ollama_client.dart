import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ollama/ollama.dart' as od;                       // ✅ correct package
import 'package:college/features/ai_mentor/data/ai_client.dart'; // Message + AIClient

/* ───────── Provider ───────── */
final ollamaClientProvider = Provider<AIClient>((_) {
  return OllamaClient(
    baseUrl: const String.fromEnvironment(
      'OLLAMA_ENDPOINT',
      defaultValue: 'http://192.168.1.12:11434',  // ← Your laptop's IP
    ),
    model: const String.fromEnvironment(
      'OLLAMA_MODEL',
      defaultValue: 'llama3',
    ),
  );
});


/* ───── Implementation ───── */
class OllamaClient implements AIClient {
  OllamaClient({required this.baseUrl, required this.model});

  final String baseUrl;
  final String model;
  late final od.Ollama _ollama =
      od.Ollama(baseUrl: Uri.parse(baseUrl));   // ctor wants a Uri

  @override
  Future<String> chat(List<Message> history) async {
    // Convert your Message → package ChatMessage
    final msgs = history
        .map((m) => od.ChatMessage(role: m.role, content: m.content))
        .toList();

    // chat() now returns a Stream<ChatChunk>; no “stream:” named arg
    final stream = _ollama.chat(msgs, model: model);

    final buffer = StringBuffer();
    await for (final chunk in stream) {
      buffer.write(chunk.message?.content ?? '');
    }
    return buffer.toString().trim();
  }
}
