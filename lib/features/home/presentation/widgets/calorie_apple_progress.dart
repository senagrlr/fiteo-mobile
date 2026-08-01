import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';

class CalorieAppleProgress extends StatelessWidget {
  const CalorieAppleProgress({
    super.key,
    required this.consumedCalories,
    required this.calorieGoal,
  });

  final int consumedCalories;
  final int calorieGoal;

  double get progress {
    if (calorieGoal <= 0) return 0;

    return consumedCalories / calorieGoal;
  }

  int get remainingCalories => calorieGoal - consumedCalories;

  bool get isOverGoal => progress > 1;

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);

    return Row(
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: CustomPaint(
            painter: AppleProgressPainter(
              progress: clampedProgress,
              isOverGoal: isOverGoal,
            ),
          ),
        ),
        const SizedBox(width: 22),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoLine(
                title: 'Remaining',
                value: remainingCalories >= 0
                    ? '$remainingCalories kcal'
                    : '${remainingCalories.abs()} kcal over',
                valueColor: isOverGoal
                    ? AppColors.appleOverGoal
                    : AppColors.calorieText,
              ),
              const SizedBox(height: 14),
              _InfoLine(
                title: 'Calorie Goal',
                value: '$calorieGoal kcal/day',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({
    required this.title,
    required this.value,
    this.valueColor,
  });

  final String title;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: AppColors.calorieText,
          fontSize: 16,
          height: 1.3,
        ),
        children: [
          TextSpan(
            text: '$title: ',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              color: valueColor ?? AppColors.calorieText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class AppleProgressPainter extends CustomPainter {
  AppleProgressPainter({
    required this.progress,
    required this.isOverGoal,
  });

  final double progress;
  final bool isOverGoal;

  @override
  void paint(Canvas canvas, Size size) {
    final applePath = _createApplePath(size);

    final backgroundPaint = Paint()
      ..color = AppColors.appleProgressBackground
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    canvas.drawPath(applePath, backgroundPaint);

    _drawProgressPath(
      canvas: canvas,
      applePath: applePath,
    );

    if (isOverGoal) {
      _drawOverGoalGlow(
        canvas: canvas,
        applePath: applePath,
      );
    }

    _drawStemAndLeaf(canvas, size);
  }

  void _drawProgressPath({
    required Canvas canvas,
    required Path applePath,
  }) {
    if (progress <= 0) return;

    final progressPaint = Paint()
      ..color = isOverGoal
          ? AppColors.appleOverGoal
          : AppColors.appleProgress
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    for (final metric in applePath.computeMetrics()) {
      final progressLength = metric.length * progress;

      final extractedPath = metric.extractPath(
        0,
        progressLength,
      );

      canvas.drawPath(
        extractedPath,
        progressPaint,
      );
    }
  }

  Path _createApplePath(Size size) {
    final width = size.width;
    final height = size.height;

    return Path()
      ..moveTo(
        width * 0.50,
        height * 0.25,
      )
      ..cubicTo(
        width * 0.61,
        height * 0.13,
        width * 0.82,
        height * 0.15,
        width * 0.87,
        height * 0.33,
      )
      ..cubicTo(
        width * 0.93,
        height * 0.55,
        width * 0.82,
        height * 0.78,
        width * 0.68,
        height * 0.88,
      )
      ..cubicTo(
        width * 0.61,
        height * 0.93,
        width * 0.55,
        height * 0.94,
        width * 0.50,
        height * 0.91,
      )
      ..cubicTo(
        width * 0.44,
        height * 0.94,
        width * 0.37,
        height * 0.93,
        width * 0.30,
        height * 0.88,
      )
      ..cubicTo(
        width * 0.16,
        height * 0.78,
        width * 0.07,
        height * 0.55,
        width * 0.13,
        height * 0.33,
      )
      ..cubicTo(
        width * 0.18,
        height * 0.15,
        width * 0.39,
        height * 0.13,
        width * 0.50,
        height * 0.25,
      )
      ..close();
  }

  void _drawStemAndLeaf(Canvas canvas, Size size) {
    final stemPaint = Paint()
      ..color = AppColors.appleStem
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    canvas.drawLine(
      Offset(
        size.width * 0.50,
        size.height * 0.23,
      ),
      Offset(
        size.width * 0.55,
        size.height * 0.09,
      ),
      stemPaint,
    );

    final leafPaint = Paint()
      ..color = AppColors.appleProgress
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final leafRect = Rect.fromCenter(
      center: Offset(
        size.width * 0.66,
        size.height * 0.10,
      ),
      width: size.width * 0.27,
      height: size.height * 0.12,
    );

    canvas.save();

    canvas.translate(
      leafRect.center.dx,
      leafRect.center.dy,
    );

    canvas.rotate(-math.pi / 7);

    canvas.translate(
      -leafRect.center.dx,
      -leafRect.center.dy,
    );

    canvas.drawOval(
      leafRect,
      leafPaint,
    );

    canvas.restore();
  }

  void _drawOverGoalGlow({
    required Canvas canvas,
    required Path applePath,
  }) {
    final glowPaint = Paint()
      ..color = AppColors.appleOverGoalGlow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 21
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    canvas.drawPath(
      applePath,
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant AppleProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isOverGoal != isOverGoal;
  }
}