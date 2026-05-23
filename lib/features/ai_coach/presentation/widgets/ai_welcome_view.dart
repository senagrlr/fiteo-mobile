import 'package:flutter/material.dart';
import 'package:fiteo_myapp/features/ai_coach/presentation/widgets/ai_message_input.dart';
import 'package:fiteo_myapp/features/ai_coach/presentation/widgets/ai_speech_bubble.dart';

class AiWelcomeView extends StatelessWidget {
  final TextEditingController controller;
  final Future<void> Function() onSend;

  const AiWelcomeView({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 170,
                child: Transform.scale(
                  scale: 1.55,
                  child: Image.asset(
                    'assets/images/fiteo_ai_mascot.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: AiSpeechBubble(),
              ),
            ],
          ),

          const SizedBox(height: 38),

          AiMessageInput(
            controller: controller,
            onSend: onSend,
            horizontalPadding: 0,
            bottomPadding: 0,
          ),
        ],
      ),
    );
  }
}