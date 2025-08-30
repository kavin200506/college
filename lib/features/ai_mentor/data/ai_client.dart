import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/message.dart';  // Import shared Message

// Remove any Message class definition from here!

abstract class AIClient {
  Future<String> sendMessage(String message);
  Future<String> chat(List<Message> history);
}

final aiClientProvider = Provider<AIClient>((ref) {
  throw UnimplementedError('AIClient provider must be overridden');
});
