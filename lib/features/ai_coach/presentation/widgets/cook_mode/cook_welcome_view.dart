import 'package:flutter/material.dart';
import 'package:fiteo_myapp/features/ai_coach/presentation/widgets/cook_mode/cook_speech_bubble.dart';

class CookWelcomeView extends StatelessWidget {
  const CookWelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: 120,
            height: 150,
            child: Transform.scale(
              scale: 1.28,
              child: Image.asset(
                'assets/images/fiteo_cook_mascot.png',
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(width: 8),

          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: CookSpeechBubble(),
            ),
          ),
        ],
      ),
    );
  }
}