import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';

class AiFeedbackCard extends StatelessWidget {
  const AiFeedbackCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: 130,
          height: 140,
          child: ClipRect(
            child: Transform.scale(
              scale: 1.55,
              child: Image.asset(
                'assets/images/fiteo_mascot.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        const SizedBox(width: 2),

        Expanded(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.homeCardBackground,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Text(
                  'You’re getting closer to your goal day by day, great job!\n\n'
                      'You’ve had 1,200 calories so far. A 20-minute light walk can help you reach your daily goal.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.homeBrown,
                    fontSize: 13,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              Positioned(
                left: -10,
                bottom: 24,
                child: CustomPaint(
                  size: const Size(14, 18),
                  painter: _SpeechBubbleTailPainter(),
                ),
              ),
            ],
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
      ..color = AppColors.homeCardBackground
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