import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/water_amount_dialog.dart';

class WaterProgressCard extends StatefulWidget {
  const WaterProgressCard({
    super.key,
    required this.consumedMl,
    required this.goalMl,
    this.onWaterAdded,
  });

  final int consumedMl;
  final int goalMl;
  final ValueChanged<int>? onWaterAdded;

  @override
  State<WaterProgressCard> createState() => _WaterProgressCardState();
}

class _WaterProgressCardState extends State<WaterProgressCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _waveController;

  late int _currentConsumedMl;

  double get progress {
    if (widget.goalMl <= 0) return 0;

    return (_currentConsumedMl / widget.goalMl).clamp(0.0, 1.0);
  }

  @override
  void initState() {
    super.initState();

    _currentConsumedMl = widget.consumedMl;

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant WaterProgressCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.consumedMl != widget.consumedMl) {
      _currentConsumedMl = widget.consumedMl;
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  Future<void> _openWaterPopup() async {
    final selectedAmount = await showDialog<int>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.25),
      builder: (context) {
        return const WaterAmountDialog();
      },
    );

    if (selectedAmount == null || selectedAmount <= 0) {
      return;
    }

    setState(() {
      _currentConsumedMl =
          (_currentConsumedMl + selectedAmount).clamp(0, widget.goalMl);
    });

    widget.onWaterAdded?.call(selectedAmount);
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).round();

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F4F0),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                return CustomPaint(
                  painter: WaterWavePainter(
                    progress: progress,
                    animationValue: _waveController.value,
                  ),
                );
              },
            ),
          ),
          const Positioned(
            top: 15,
            left: 14,
            child: Text(
              'Water',
              style: TextStyle(
                color: Color(0xFF74433E),
                fontSize: 15,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Material(
              color: const Color(0xFFCFE5FA),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(17),
              ),
              child: InkWell(
                onTap: _openWaterPopup,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(17),
                ),
                child: const SizedBox(
                  width: 39,
                  height: 39,
                  child: Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 29,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$percentage%',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '$_currentConsumedMl/${widget.goalMl} ml',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WaterWavePainter extends CustomPainter {
  WaterWavePainter({
    required this.progress,
    required this.animationValue,
  });

  final double progress;
  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final visibleProgress = progress.clamp(0.08, 1.0);

    final waterLevel = size.height * (1 - visibleProgress);
    final phase = animationValue * 2 * math.pi;

    _drawWave(
      canvas: canvas,
      size: size,
      waterLevel: waterLevel,
      phase: phase,
      amplitude: 7,
      wavelength: size.width * 1.15,
      color: const Color(0xFFB4D8FA),
    );

    _drawWave(
      canvas: canvas,
      size: size,
      waterLevel: waterLevel + 8,
      phase: phase + math.pi,
      amplitude: 6,
      wavelength: size.width,
      color: const Color(0xFF94C5F7),
    );
  }

  void _drawWave({
    required Canvas canvas,
    required Size size,
    required double waterLevel,
    required double phase,
    required double amplitude,
    required double wavelength,
    required Color color,
  }) {
    final path = Path();

    path.moveTo(0, waterLevel);

    for (double x = 0; x <= size.width; x += 1) {
      final y = waterLevel +
          math.sin(
            ((x / wavelength) * 2 * math.pi) + phase,
          ) *
              amplitude;

      path.lineTo(x, y);
    }

    path
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WaterWavePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.animationValue != animationValue;
  }
}