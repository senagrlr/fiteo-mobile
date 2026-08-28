import 'dart:math' as math;

import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/plan_tracking_stats.dart';

class PlanWeightProgressChart extends StatefulWidget {
  final DateTime planActivatedAt;
  final DateTime? expectedGoalDate;
  final double planStartWeight;
  final double targetWeight;
  final List<PlanTrackingWeightPoint> weightPoints;
  final String weightUnit;

  const PlanWeightProgressChart({
    super.key,
    required this.planActivatedAt,
    required this.expectedGoalDate,
    required this.planStartWeight,
    required this.targetWeight,
    required this.weightPoints,
    required this.weightUnit,
  });

  @override
  State<PlanWeightProgressChart> createState() =>
      _PlanWeightProgressChartState();
}

class _PlanWeightProgressChartState
    extends State<PlanWeightProgressChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1500,
      ),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<FlSpot> _animatedSpots(List<FlSpot> spots, double value) {
    if (spots.isEmpty) return const [];

    final startY = spots.first.y;

    return spots
        .map((spot) => FlSpot(
      spot.x,
      startY + ((spot.y - startY) * value),
    ))
        .toList();
  }

  double _displayWeight(double weightKg) {
    return widget.weightUnit.toLowerCase() == 'lb'
        ? weightKg * 2.2046226218
        : weightKg;
  }

  DateTime get _chartEndDate {
    final expectedGoalDate = widget.expectedGoalDate;

    if (expectedGoalDate != null &&
        expectedGoalDate.isAfter(widget.planActivatedAt)) {
      return expectedGoalDate;
    }

    final latestDate =
    widget.weightPoints.isEmpty ? null : widget.weightPoints.last.date;

    if (latestDate != null && latestDate.isAfter(widget.planActivatedAt)) {
      return latestDate;
    }

    return widget.planActivatedAt.add(const Duration(days: 28));
  }

  double get _totalDays {
    return math.max(
      1,
      _chartEndDate.difference(widget.planActivatedAt).inDays,
    ).toDouble();
  }

  List<FlSpot> get _actualWeightSpots {
    final spots = <FlSpot>[
      FlSpot(0, _displayWeight(widget.planStartWeight)),
    ];

    for (final point in widget.weightPoints) {
      if (point.date.isBefore(widget.planActivatedAt) ||
          point.date.isAfter(_chartEndDate)) {
        continue;
      }

      final x =
      point.date.difference(widget.planActivatedAt).inDays.toDouble();

      final y = _displayWeight(point.weightKg);

      if (x == 0) {
        spots[0] = FlSpot(0, y);
      } else {
        spots.add(FlSpot(x, y));
      }
    }

    return spots;
  }

  List<FlSpot> get _expectedWeightSpots {
    return [
      FlSpot(0, _displayWeight(widget.planStartWeight)),
      FlSpot(_totalDays, _displayWeight(widget.targetWeight)),
    ];
  }

  List<DateTime> get _bottomDates {
    final totalDays = _chartEndDate.difference(widget.planActivatedAt).inDays;

    return List.generate(4, (index) {
      final offset = (totalDays * index / 3).round();
      return widget.planActivatedAt.add(Duration(days: offset));
    });
  }

  List<double> get _bottomXValues {
    return _bottomDates
        .map((date) =>
        date.difference(widget.planActivatedAt).inDays.toDouble())
        .toList();
  }

  double get _yInterval {
    final values = <double>[
      _displayWeight(widget.planStartWeight),
      _displayWeight(widget.targetWeight),
      ..._actualWeightSpots.map((spot) => spot.y),
    ];

    final lowest = values.reduce(math.min);
    final highest = values.reduce(math.max);
    final range = math.max(1.0, highest - lowest);

    return math.max(1.0, (range / 4).ceilToDouble());
  }

  double get _minY {
    final values = <double>[
      _displayWeight(widget.planStartWeight),
      _displayWeight(widget.targetWeight),
      ..._actualWeightSpots.map((spot) => spot.y),
    ];

    final lowest = values.reduce(math.min);
    return (lowest / _yInterval).floor() * _yInterval - _yInterval;
  }

  double get _maxY {
    final values = <double>[
      _displayWeight(widget.planStartWeight),
      _displayWeight(widget.targetWeight),
      ..._actualWeightSpots.map((spot) => spot.y),
    ];

    final highest = values.reduce(math.max);
    return (highest / _yInterval).ceil() * _yInterval + _yInterval;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 340,
      padding: const EdgeInsets.fromLTRB(
        10,
        20,
        10,
        12,
      ),
      decoration: BoxDecoration(
        color: AppColors.calendarSummaryCardBackground,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: AppColors.calendarSummaryShadow,
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
            ),
            child: Text(
              context.l10n.weightProgress,
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.homeBrown,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
            ),
            child: Row(
              children: [
                _LegendItem(
                  title: context.l10n.actualWeight,
                  color: AppColors.homeBrown,
                ),

                const SizedBox(width: 18),

                _LegendItem(
                  title: context.l10n.expectedWeight,
                  color:
                  AppColors.authButtonGreen.withValues(
                    alpha: 0.45,
                  ),
                  dashed: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  top: 32,
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return LineChart(
                        _chartData(
                          context,
                          _animation.value,
                        ),
                        duration: Duration.zero,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  LineChartData _chartData(
      BuildContext context,
      double animationValue,
      ) {
    final actualWeightSpots = _actualWeightSpots;
    final expectedWeightSpots = _expectedWeightSpots;

    return LineChartData(
      minX: 0,
      maxX: _totalDays,

      minY: _minY,
      maxY: _maxY,

      clipData: const FlClipData.all(),

      borderData: FlBorderData(
        show: false,
      ),

      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: _yInterval,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: AppColors.homeBrown.withValues(
              alpha: 0.07,
            ),
            strokeWidth: 1,
          );
        },
      ),

      titlesData: FlTitlesData(
        topTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),

        rightTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),

        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 27,
            interval: _yInterval,
            getTitlesWidget: (value, meta) {
              if ((value - _minY).abs() < 0.01) {
                return const SizedBox.shrink();
              }

              return SideTitleWidget(
                meta: meta,
                space: 3,
                child: Text(
                  value.toStringAsFixed(value % 1 == 0 ? 0 : 1),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.planTrackingSecondaryLabel,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ),

        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 35,
            interval: 1,
            getTitlesWidget: (value, meta) {
              var index = -1;

              for (var i = 0; i < _bottomXValues.length; i++) {
                if ((value - _bottomXValues[i]).abs() < 0.5) {
                  index = i;
                  break;
                }
              }

              if (index == -1) return const SizedBox.shrink();

              final date = _bottomDates[index];
              final locale = Localizations.localeOf(context).toLanguageTag();
              final month = DateFormat.MMM(locale).format(date);

              return SideTitleWidget(
                meta: meta,
                space: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      date.day.toString(),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.planTrackingSecondaryLabel,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      month,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.planTrackingSecondaryLabel,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),

      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (spots) {
            return spots.map((spot) {
              return LineTooltipItem(
                '${spot.y.toStringAsFixed(1)} ${widget.weightUnit}',
                AppTextStyles.labelSmall.copyWith(
                  color: AppColors.onPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              );
            }).toList();
          },
        ),
      ),

      lineBarsData: [
        // PLANLANAN İLERLEME
        LineChartBarData(
          spots: _animatedSpots(
            expectedWeightSpots,
            animationValue,
          ),
          isCurved: true,
          curveSmoothness: 0.25,
          color:
          AppColors.authButtonGreen.withValues(
            alpha: 0.35,
          ),
          barWidth: 3,
          dashArray: [7, 6],
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: animationValue > 0.95,
            checkToShowDot: (spot, barData) {
              return (spot.x - expectedWeightSpots.last.x).abs() < 0.01;
            },
            getDotPainter: (
                spot,
                percent,
                barData,
                index,
                ) {
              return FlDotCirclePainter(
                radius: 5,
                color: AppColors.surfacePrimary,
                strokeWidth: 3,
                strokeColor:
                AppColors.authButtonGreen,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: false,
          ),
        ),

        if (actualWeightSpots.isNotEmpty)
        LineChartBarData(
          spots: _animatedSpots(
            actualWeightSpots,
            animationValue,
          ),
          isCurved: true,
          curveSmoothness: 0.25,
          color: AppColors.homeBrown,
          barWidth: 4,
          isStrokeCapRound: true,
          isStrokeJoinRound: true,
          dotData: FlDotData(
            show: animationValue > 0.95,
            checkToShowDot: (spot, barData) {
              return spot.x == 0 ||
                  spot.x == actualWeightSpots.last.x;
            },
            getDotPainter: (
                spot,
                percent,
                barData,
                index,
                ) {
              final isCurrent =
                  spot.x == actualWeightSpots.last.x;

              return FlDotCirclePainter(
                radius: isCurrent ? 6 : 5,
                color: AppColors.surfacePrimary,
                strokeWidth: 3,
                strokeColor: AppColors.homeBrown,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: false,
          ),
        ),
      ],

      // HEDEF KİLO
      extraLinesData: ExtraLinesData(
        horizontalLines: [
          HorizontalLine(
            y: _displayWeight(widget.targetWeight),
            color:
            AppColors.authButtonGreen.withValues(
              alpha: 0.7,
            ),
            strokeWidth: 1.5,
            dashArray: [5, 5],
            label: HorizontalLineLabel(
              show: true,
              alignment: Alignment.topRight,

              // Hedef kilo yazısını yeşil
              // noktadan biraz daha yukarı aldık.
              padding: const EdgeInsets.only(
                right: 4,
                bottom: 11,
              ),

              style:
              AppTextStyles.labelSmall.copyWith(
                color: AppColors.authButtonGreen,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
              labelResolver: (_) =>
              '${_displayWeight(widget.targetWeight).toStringAsFixed(1)} ${widget.weightUnit}',
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String title;
  final Color color;
  final bool dashed;

  const _LegendItem({
    required this.title,
    required this.color,
    this.dashed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (dashed)
          Row(
            children: [
              _Dash(color: color),
              const SizedBox(width: 3),
              _Dash(color: color),
              const SizedBox(width: 3),
              _Dash(color: color),
            ],
          )
        else
          Container(
            width: 20,
            height: 4,
            decoration: BoxDecoration(
              color: color,
              borderRadius:
              BorderRadius.circular(10),
            ),
          ),

        const SizedBox(width: 7),

        Text(
          title,
          style:
          AppTextStyles.labelSmall.copyWith(
            color:
            AppColors.planTrackingSecondaryLabel,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _Dash extends StatelessWidget {
  final Color color;

  const _Dash({
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 3,
      decoration: BoxDecoration(
        color: color,
        borderRadius:
        BorderRadius.circular(5),
      ),
    );
  }
}