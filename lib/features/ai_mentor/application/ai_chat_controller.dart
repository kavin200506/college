import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/ai_client.dart';
import '../../../core/models/message.dart';
// Message class - define it here or create a shared file


  

// AI Chat Controller State Notifier
class AIChatCtrl extends StateNotifier<List<Message>> {
  final Ref ref;
  bool _disposed = false;
  bool _waiting = false;

  AIChatCtrl(this.ref) : super([
    const Message('system', 'You are a helpful college mentor. Answer concisely and motivate students.'),
  ]);

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<void> send(String text) async {
    // Safety checks
    if (_disposed || _waiting || text.trim().isEmpty) return;

    // Add user message to state
    final userMessage = Message('user', text.trim());
    state = [...state, userMessage];
    
    _waiting = true;

    try {
      // Get AI client and send message
      final aiClient = ref.read(aiClientProvider);
      final reply = await aiClient.chat(state);
      
      // Check if still mounted before updating state
      if (!_disposed) {
        final assistantMessage = Message('assistant', reply);
        state = [...state, assistantMessage];
      }
    } catch (e) {
      // Handle errors gracefully
      if (!_disposed) {
        final errorMessage = Message(
          'assistant', 
          'Sorry, I encountered an error while processing your request. Please try again.'
        );
        state = [...state, errorMessage];
      }
    } finally {
      _waiting = false;
    }
  }

  // Clear chat history
  void clear() {
    if (_disposed) return;
    
    state = [
      const Message('system', 'You are a helpful college mentor. Answer concisely and motivate students.'),
    ];
  }

  // Add a message directly (useful for testing)
  void addMessage(Message message) {
    if (_disposed) return;
    state = [...state, message];
  }

  // Remove last message
  void removeLastMessage() {
    if (_disposed || state.length <= 1) return;
    state = state.sublist(0, state.length - 1);
  }

  // Get message count
  int get messageCount => state.length;

  // Check if waiting for AI response
  bool get isWaiting => _waiting;

  // Check if has user messages beyond system message
  bool get hasUserMessages => state.length > 1;

  // Get user messages only
  List<Message> get userMessages => state.where((msg) => msg.role == 'user').toList();

  // Get assistant messages only
  List<Message> get assistantMessages => state.where((msg) => msg.role == 'assistant').toList();

  // Get the last message
  Message? get lastMessage => state.isNotEmpty ? state.last : null;

  // Check if the last message was from user
  bool get lastMessageFromUser => lastMessage?.role == 'user';
}

// Riverpod Provider
final aiChatProvider = StateNotifierProvider<AIChatCtrl, List<Message>>((ref) {
  return AIChatCtrl(ref);
});

// Helper providers for easier access
final aiChatMessagesProvider = Provider<List<Message>>((ref) {
  return ref.watch(aiChatProvider);
});

final aiChatWaitingProvider = Provider<bool>((ref) {
  return ref.watch(aiChatProvider.notifier).isWaiting;
});

final aiChatUserMessagesProvider = Provider<List<Message>>((ref) {
  return ref.watch(aiChatProvider.notifier).userMessages;
});

final aiChatAssistantMessagesProvider = Provider<List<Message>>((ref) {
  return ref.watch(aiChatProvider.notifier).assistantMessages;
});

final aiChatLastMessageProvider = Provider<Message?>((ref) {
  return ref.watch(aiChatProvider.notifier).lastMessage;
});
