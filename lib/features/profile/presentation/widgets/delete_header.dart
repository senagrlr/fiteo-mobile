import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';

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
            color: const Color(0xFFF3F1EC),
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: const _TypewriterBubbleText(
            text: 'Sorry to see you go',
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
      style: const TextStyle(
        color: AppColors.homeBrown,
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _SpeechBubbleTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF3F1EC)
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