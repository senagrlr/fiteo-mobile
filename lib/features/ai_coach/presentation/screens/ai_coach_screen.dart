import 'package:flutter/material.dart';
import 'package:fiteo_myapp/features/ai_coach/presentation/widgets/ai_message_input.dart';
import 'package:fiteo_myapp/features/ai_coach/presentation/widgets/ai_welcome_view.dart';
import 'package:fiteo_myapp/features/ai_coach/presentation/widgets/ai_bot_bubble.dart';
import 'package:fiteo_myapp/features/ai_coach/presentation/widgets/ai_user_bubble.dart';

class AiCoachScreen extends StatefulWidget {
  const AiCoachScreen({super.key});

  @override
  State<AiCoachScreen> createState() => _AiCoachScreenState();
}

class _AiCoachScreenState extends State<AiCoachScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> messages = [];

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add(text);
      _messageController.clear();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasMessages = messages.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: hasMessages
            ? Column(
          children: [
            Expanded(child: _buildChatView()),
            AiMessageInput(
              controller: _messageController,
              onSend: _sendMessage,
            ),
          ],
        )
            : AiWelcomeView(
          controller: _messageController,
          onSend: _sendMessage,
        ),
      ),
    );
  }

  Widget _buildChatView() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      itemCount: messages.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 18),
            child: Align(
              alignment: Alignment.centerLeft,
              child: AiBotBubble(
                text: 'Hi, I’m Fiteo. Tell me your goal and I’ll guide you.',
              ),
            ),
          );
        }

        final message = messages[index - 1];

        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Align(
            alignment: Alignment.centerRight,
            child: AiUserBubble(text: message),
          ),
        );
      },
    );
  }
}