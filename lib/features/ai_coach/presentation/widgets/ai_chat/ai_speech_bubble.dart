import 'dart:async';

import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';

class AiSpeechBubble extends StatefulWidget {
  const AiSpeechBubble({super.key});

  @override
  State<AiSpeechBubble> createState() =>
      _AiSpeechBubbleState();
}

class _AiSpeechBubbleState extends State<AiSpeechBubble> {
  String visibleText = '';
  int index = 0;

  Timer? _typingTimer;
  bool _typingStarted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_typingStarted) {
      _typingStarted = true;
      _startTyping(
        context.l10n.aiWelcomeMessage,
      );
    }
  }

  void _startTyping(String fullText) {
    _typingTimer = Timer.periodic(
      const Duration(milliseconds: 35),
          (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (index < fullText.length) {
          setState(() {
            visibleText += fullText[index];
            index++;
          });
        } else {
          timer.cancel();
        }
      },
    );
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
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
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.homeBrown,
              fontSize: 15,
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
  bool shouldRepaint(
      covariant CustomPainter oldDelegate,
      ) =>
      false;
}