import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:college/features/ai_mentor/data/ai_client.dart';

// Main Screen Widget
class AIMentorScreen extends ConsumerStatefulWidget {
  const AIMentorScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AIMentorScreen> createState() => _AIMentorScreenState();
}

class _AIMentorScreenState extends ConsumerState<AIMentorScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [
    Message(
      'assistant',
      "Hello! I am your friendly AI Mentor. Ask me anything about your studies or college life!",
    ),
  ];
  bool _loading = false;
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> sendMessage(String userMsg) async {
    final client = ref.read(aiClientProvider);
    setState(() {
      _messages.add(Message('user', userMsg));
      _loading = true;
    });

    try {
      final replyText = await client.chat(_messages);
      setState(() {
        _messages.add(Message('assistant', replyText));
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(Message('assistant', "Failed to connect to local AI."));
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6A11CB), // Deep Purple
              Color(0xFF2575FC), // Bright Blue
            ],
          ),
        ),
        child: Column(
          children: [
            // AppBar with glittering title
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        colors: const [
                          Colors.white,
                          Colors.blue,
                          Colors.purple,
                          Colors.white,
                        ],
                        stops: [
                          _animationController.value,
                          _animationController.value + 0.1,
                          _animationController.value + 0.2,
                          _animationController.value + 0.3,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        tileMode: TileMode.mirror,
                      ).createShader(bounds);
                    },
                    child: Text(
                      'Ollama Llama3',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (_, i) {
                  final m = _messages[i];
                  return ChatBubble(message: m);
                },
              ),
            ),
            if (_loading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            const Divider(height: 1, color: Colors.white),
            ChatInput(
              controller: _controller,
              onSubmitted: (txt) {
                if (txt.trim().isNotEmpty) {
                  sendMessage(txt.trim());
                  _controller.clear();
                }
              },
              loading: _loading,
            ),
          ],
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final Message message;

  const ChatBubble({required this.message, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isUser ? Colors.white.withOpacity(0.9) : const Color(0xFFF0F0F0).withOpacity(0.9),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isUser ? const Radius.circular(20) : const Radius.circular(0),
            bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Text(
          message.content,
          style: GoogleFonts.poppins(
            color: isUser ? const Color(0xFF2575FC) : Colors.black87,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSubmitted;
  final bool loading;

  const ChatInput({
    required this.controller,
    required this.onSubmitted,
    required this.loading,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Ask me anything...',
                hintStyle: GoogleFonts.poppins(color: Colors.white.withOpacity(0.6)),
                filled: true,
                fillColor: Colors.white.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              style: GoogleFonts.poppins(color: Colors.white),
              onSubmitted: loading ? null : onSubmitted,
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed: loading
                ? null
                : () {
                    final txt = controller.text.trim();
                    if (txt.isNotEmpty) {
                      onSubmitted(txt);
                    }
                  },
            backgroundColor: Colors.white,
            elevation: 4,
            child: Icon(
              Icons.send,
              color: loading ? Colors.grey : const Color(0xFF2575FC),
            ),
          ),
        ],
      ),
    );
  }
}
