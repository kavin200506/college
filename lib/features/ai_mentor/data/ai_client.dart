import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Message model reused across all AI back-ends
class Message {
  Message(this.role, this.content);

  final String role;   // 'system' | 'user' | 'assistant'
  final String content;
}

/// Abstract interface every back-end (OpenAI, Ollama, DeepSeek, etc.) must implement.
abstract class AIClient {
  /// Takes the full chat history and returns the assistant’s next reply.
  Future<String> chat(List<Message> history);
}

/// Global provider used by the app.
/// In `main.dart` you override this with the concrete client you want to use:
///
///   aiClientProvider.overrideWithProvider(deepSeekClientProvider)
///
final aiClientProvider = Provider<AIClient>((ref) {
  throw UnimplementedError(
      'No AIClient implementation provided. Override aiClientProvider in main().');
});
