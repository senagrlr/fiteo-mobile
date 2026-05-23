import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';

class CookSpeechBubble extends StatefulWidget {
  const CookSpeechBubble({super.key});

  @override
  State<CookSpeechBubble> createState() => _CookSpeechBubbleState();
}

class _CookSpeechBubbleState extends State<CookSpeechBubble> {
  final String fullText =
      "Type ingredients,\nI’ll cook up best recipe for you.";

  String visibleText = "";
  int index = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() {
    timer = Timer.periodic(const Duration(milliseconds: 35), (timer) {
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
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 20,
          ),
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
            painter: _CookBubbleTailPainter(),
          ),
        ),
      ],
    );
  }
}

class _CookBubbleTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.onboardingBackground
      ..style = PaintingStyle.fill;

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