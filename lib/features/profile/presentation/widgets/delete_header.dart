import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';

class DeleteHeader extends StatelessWidget {
  const DeleteHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/fiteo_sad_mascot.png',
            width: 96,
            height: 110,
            fit: BoxFit.contain,
          ),

          const SizedBox(width: 8),

          const Expanded(
            child: _DeleteSpeechBubble(),
          ),
        ],
      ),
    );
  }
}

class _DeleteSpeechBubble extends StatelessWidget {
  const _DeleteSpeechBubble();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          width: double.infinity,
          height: 62,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          decoration: BoxDecoration(
            color: AppColors.speechBubbleBackground,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: _TypewriterBubbleText(
            text: context.l10n.sorryToSeeYouGo,
          ),
        ),

        Positioned(
          left: -11,
          child: CustomPaint(
            size: const Size(13, 18),
            painter: _SpeechBubbleTailPainter(),
          ),
        ),
      ],
    );
  }
}

class _TypewriterBubbleText extends StatefulWidget {
  final String text;

  const _TypewriterBubbleText({
    required this.text,
  });

  @override
  State<_TypewriterBubbleText> createState() =>
      _TypewriterBubbleTextState();
}

class _TypewriterBubbleTextState
    extends State<_TypewriterBubbleText> {
  String visibleText = '';
  int index = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
      const Duration(milliseconds: 45),
          (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (index < widget.text.length) {
          setState(() {
            visibleText += widget.text[index];
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
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      visibleText,
      textAlign: TextAlign.center,
      style: AppTextStyles.titleMedium.copyWith(
        color: AppColors.homeBrown,
        fontSize: 14,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _SpeechBubbleTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.speechBubbleBackground
      ..style = PaintingStyle.fill;

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
      ) {
    return false;
  }
}