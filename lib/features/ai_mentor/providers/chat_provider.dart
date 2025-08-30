import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Chat Message Model
class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
  });

  ChatMessage copyWith({
    String? id,
    String? content,
    bool? isUser,
    DateTime? timestamp,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

// Chat State Class
class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Chat State Notifier
class ChatNotifier extends StateNotifier<ChatState> {
  bool _disposed = false;

  ChatNotifier() : super(const ChatState()) {
    _addWelcomeMessage();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _addWelcomeMessage() {
    if (_disposed) return;
    
    final welcomeMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: "Hello! I'm your AI study mentor. How can I help you with your studies today?",
      isUser: false,
      timestamp: DateTime.now(),
    );
    
    state = state.copyWith(
      messages: [welcomeMessage],
    );
  }

  // Add user message
  void addUserMessage(String content) {
    if (_disposed) return;
    
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, message],
      isLoading: true,
      error: '',
    );
  }

  // Add AI response
  void addAIResponse(String content) {
    if (_disposed) return;
    
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isUser: false,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, message],
      isLoading: false,
      error: '',
    );
  }

  // Set loading state
  void setLoading(bool loading) {
    if (_disposed) return;
    state = state.copyWith(isLoading: loading);
  }

  // Set error
  void setError(String? error) {
    if (_disposed) return;
    state = state.copyWith(
      error: error ?? '',
      isLoading: false,
    );
  }

  // Clear error
  void clearError() {
    if (_disposed) return;
    state = state.copyWith(error: '');
  }

  // Clear chat history
  void clearChat() {
    if (_disposed) return;
    state = const ChatState();
    _addWelcomeMessage();
  }

  // Get message count for UI
  int get messageCount => state.messages.length;
  
  // Check if chat has messages beyond welcome
  bool get hasUserMessages => state.messages.length > 1;
}

// Riverpod Providers
final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier();
});

// Helper providers for specific state access
final chatMessagesProvider = Provider<List<ChatMessage>>((ref) {
  return ref.watch(chatProvider).messages;
});

final chatLoadingProvider = Provider<bool>((ref) {
  return ref.watch(chatProvider).isLoading;
});

final chatErrorProvider = Provider<String?>((ref) {
  return ref.watch(chatProvider).error;
});
