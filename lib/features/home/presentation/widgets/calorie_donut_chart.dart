import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';

class CalorieDonutChart extends StatefulWidget {
  final double consumed;
  final double burned;

  const CalorieDonutChart({
    super.key,
    required this.consumed,
    required this.burned,
  });

  @override
  State<CalorieDonutChart> createState() => _CalorieDonutChartState();
}

class _CalorieDonutChartState extends State<CalorieDonutChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final net = widget.consumed - widget.burned;

    return Column(
      children: [
        SizedBox(
          width: 220,
          height: 220,
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, _) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(220, 220),
                    painter: _DonutChartPainter(
                      consumed: widget.consumed,
                      burned: widget.burned,
                      progress: animation.value,
                    ),
                  ),

                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Consumed',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.calendarCompleted.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${widget.consumed.toInt()} kcal',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.calendarCompleted,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        'Burned',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.homeBrown.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${widget.burned.toInt()} kcal',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.homeBrown,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),

        const SizedBox(height: 16),

        Text(
          'Net: ${net.toInt()} kcal',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
class _DonutChartPainter extends CustomPainter {
  final double consumed;
  final double burned;
  final double progress;

  _DonutChartPainter({
    required this.consumed,
    required this.burned,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final total = (consumed + burned == 0) ? 1 : consumed + burned;
    final strokeWidth = 22.0;

    final rect = Offset.zero & size;

    final consumedSweep = (consumed / total) * 2 * pi * progress;
    final burnedSweep = (burned / total) * 2 * pi * progress;

    final consumedPaint = Paint()
      ..color = AppColors.calendarCompleted
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final burnedPaint = Paint()
      ..color = AppColors.homeBrown
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const startAngle = -pi / 2;

    canvas.drawArc(
      rect.deflate(strokeWidth / 2),
      startAngle,
      consumedSweep,
      false,
      consumedPaint,
    );

    canvas.drawArc(
      rect.deflate(strokeWidth / 2),
      startAngle + consumedSweep,
      burnedSweep,
      false,
      burnedPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}