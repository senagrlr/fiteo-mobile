import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';

class AiSpeechBubble extends StatefulWidget {
  const AiSpeechBubble({super.key});

  @override
  State<AiSpeechBubble> createState() => _AiSpeechBubbleState();
}

class _AiSpeechBubbleState extends State<AiSpeechBubble> {
  final String fullText =
      "Hi, I’m Fiteo\nLet’s improve your journey together.";

  String visibleText = "";
  int index = 0;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() {
    Timer.periodic(const Duration(milliseconds: 35), (timer) {
      if (index < fullText.length) {
        setState(() {
          visibleText += fullText[index];
          index++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          decoration: BoxDecoration(
            color: AppColors.onboardingBackground,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            visibleText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.homeBrown,
              fontSize: 18,
              height: 1.4,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        Positioned(
          left: -12,
          bottom: 28,
          child: CustomPaint(
            size: const Size(16, 20),
            painter: _SpeechBubbleTailPainter(),
          ),
        ),
      ],
    );
  }
}

class _SpeechBubbleTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.onboardingBackground;

    final path = Path()
      ..moveTo(size.width, 0)
      ..lineTo(0, size.height / 2)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}