// lib/features/ai_mentor/application/ai_chat_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/ai_client.dart';

final aiChatProvider = StateNotifierProvider<AIChatCtrl, List<Message>>((ref) {
  return AIChatCtrl(ref);  // Pass ref directly, not ref.read
});

class AIChatCtrl extends StateNotifier<List<Message>> {
  AIChatCtrl(this.ref)  // Change from Reader _read to Ref ref
      : super([
          Message('system',
              'You are a helpful college mentor. Answer concisely and motivate students.'),
        ]);

  final Ref ref;  // Change from Reader to Ref
  bool _waiting = false;

  Future<void> send(String text) async {
    if (_waiting) return;
    state = [...state, Message('user', text)];
    _waiting = true;
    final reply = await ref.read(aiClientProvider).chat(state);  // Use ref.read instead of _read
    _waiting = false;
    state = [...state, Message('assistant', reply)];
  }
}
