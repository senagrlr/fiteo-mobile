import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';

class DeleteHeader extends StatelessWidget {
  const DeleteHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 235,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -55,
            left: -35,
            right: -55,
            child: Image.asset(
              'assets/images/profile_header_bg.png',
              width: MediaQuery.of(context).size.width + 70,
              height: 270,
              fit: BoxFit.fill,
            ),
          ),

          Positioned(
            left: 24,
            bottom: 34,
            right: 24,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image.asset(
                  'assets/images/fiteo_sad_mascot.png',
                  width: 140,
                  height: 140,
                  fit: BoxFit.contain,
                ),

                const SizedBox(width: 5),

                Expanded(
                  child: Transform.translate(
                    offset: const Offset(0, -35), // 🔥 yukarı çeker
                    child: const _DeleteSpeechBubble(),
                  ),
                ),
              ],
            ),
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
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical:20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Center(
            child: _TypewriterBubbleText(
              text: 'I am sorry to see you go',
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

class _TypewriterBubbleText extends StatefulWidget {
  final String text;

  const _TypewriterBubbleText({
    required this.text,
  });

  @override
  State<_TypewriterBubbleText> createState() => _TypewriterBubbleTextState();
}

class _TypewriterBubbleTextState extends State<_TypewriterBubbleText> {
  String visibleText = '';
  int index = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(milliseconds: 45), (timer) {
      if (index < widget.text.length) {
        setState(() {
          visibleText += widget.text[index];
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
    return Text(
      visibleText,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: AppColors.homeBrown,
        fontSize: 17,
        height: 1.25,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _SpeechBubbleTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
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