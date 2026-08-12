import 'dart:math';

import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';

class CalorieDonutChart extends StatefulWidget {
  final double consumed;
  final double burned;

  const CalorieDonutChart({
    super.key,
    required this.consumed,
    required this.burned,
  });

  @override
  State<CalorieDonutChart> createState() =>
      _CalorieDonutChartState();
}

class _CalorieDonutChartState
    extends State<CalorieDonutChart>
    with TickerProviderStateMixin {
  late final AnimationController _chartController;
  late final Animation<double> _chartAnimation;

  late final AnimationController _emptyController;
  late final Animation<double> _emptyPulseAnimation;

  bool _showNet = false;

  bool get _hasData =>
      widget.consumed > 0 || widget.burned > 0;

  @override
  void initState() {
    super.initState();

    _chartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _chartAnimation = CurvedAnimation(
      parent: _chartController,
      curve: Curves.easeOutCubic,
    );

    _chartController.forward();

    _emptyController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _emptyPulseAnimation = CurvedAnimation(
      parent: _emptyController,
      curve: Curves.easeInOut,
    );

    _emptyController.repeat(
      reverse: true,
    );
  }

  @override
  void didUpdateWidget(
      covariant CalorieDonutChart oldWidget,
      ) {
    super.didUpdateWidget(oldWidget);

    final oldHasData =
        oldWidget.consumed > 0 ||
            oldWidget.burned > 0;

    if (!oldHasData && _hasData) {
      _chartController
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _chartController.dispose();
    _emptyController.dispose();

    super.dispose();
  }

  Future<void> _showNetTemporarily() async {
    setState(() {
      _showNet = true;
    });

    await Future.delayed(
      const Duration(seconds: 2),
    );

    if (!mounted) return;

    setState(() {
      _showNet = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final net =
        widget.consumed - widget.burned;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _showNetTemporarily,
      child: SizedBox(
        width: 220,
        height: 220,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _chartAnimation,
            _emptyPulseAnimation,
          ]),
          builder: (context, _) {
            return Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(
                    220,
                    220,
                  ),
                  painter: _DonutChartPainter(
                    consumed: widget.consumed,
                    burned: widget.burned,
                    progress: _chartAnimation.value,
                    hasData: _hasData,
                    pulseValue:
                    _emptyPulseAnimation.value,
                  ),
                ),

                AnimatedSwitcher(
                  duration: const Duration(
                    milliseconds: 220,
                  ),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: _showNet
                      ? _NetContent(
                    key: const ValueKey(
                      'net',
                    ),
                    net: net,
                  )
                      : _CaloriesContent(
                    key: const ValueKey(
                      'calories',
                    ),
                    consumed:
                    widget.consumed,
                    burned:
                    widget.burned,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CaloriesContent extends StatelessWidget {
  const _CaloriesContent({
    super.key,
    required this.consumed,
    required this.burned,
  });

  final double consumed;
  final double burned;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          context.l10n.consumed,
          style: AppTextStyles.bodySmall.copyWith(
            fontSize: 14,
            color:
            AppColors.calendarCompleted.withValues(
              alpha: 0.8,
            ),
            fontWeight: FontWeight.w500,
          ),
        ),

        Text(
          '${consumed.toInt()} kcal',
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.calendarCompleted,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          context.l10n.burned,
          style: AppTextStyles.bodySmall.copyWith(
            fontSize: 14,
            color:
            AppColors.homeBrown.withValues(
              alpha: 0.6,
            ),
            fontWeight: FontWeight.w500,
          ),
        ),

        Text(
          '${burned.toInt()} kcal',
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.homeBrown,
          ),
        ),
      ],
    );
  }
}

class _NetContent extends StatelessWidget {
  const _NetContent({
    super.key,
    required this.net,
  });

  final double net;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          context.l10n.net,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.homeSecondaryValue,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          '${net.toInt()} kcal',
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.homeBrown,
            fontSize: 22,
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
  final bool hasData;
  final double pulseValue;

  _DonutChartPainter({
    required this.consumed,
    required this.burned,
    required this.progress,
    required this.hasData,
    required this.pulseValue,
  });

  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    final rect = Offset.zero & size;

    if (!hasData) {
      final pulseStroke =
          16.0 + (pulseValue * 8.0);

      final pulseOpacity =
          0.35 + (pulseValue * 0.45);

      final emptyPaint = Paint()
        ..color =
        AppColors.donutEmptyTrack.withValues(
          alpha: pulseOpacity,
        )
        ..strokeWidth = pulseStroke
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..isAntiAlias = true;

      canvas.drawArc(
        rect.deflate(pulseStroke / 2),
        -pi / 2,
        2 * pi,
        false,
        emptyPaint,
      );

      return;
    }

    const strokeWidth = 22.0;

    final total = consumed + burned == 0
        ? 1.0
        : consumed + burned;

    final consumedSweep =
        (consumed / total) *
            2 *
            pi *
            progress;

    final burnedSweep =
        (burned / total) *
            2 *
            pi *
            progress;

    final consumedPaint = Paint()
      ..color = AppColors.calendarCompleted
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final burnedPaint = Paint()
      ..color = AppColors.homeBrown
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

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
  bool shouldRepaint(
      covariant _DonutChartPainter oldDelegate,
      ) {
    return oldDelegate.consumed != consumed ||
        oldDelegate.burned != burned ||
        oldDelegate.progress != progress ||
        oldDelegate.hasData != hasData ||
        oldDelegate.pulseValue != pulseValue;
  }
}