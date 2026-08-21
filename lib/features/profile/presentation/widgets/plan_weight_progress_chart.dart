import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';

class PlanWeightProgressChart extends StatefulWidget {
  const PlanWeightProgressChart({
    super.key,
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

  final List<FlSpot> actualWeightSpots = const [
    FlSpot(0, 55),
    FlSpot(1, 54.4),
    FlSpot(2, 53.8),
    FlSpot(3, 53.4),
  ];

  final List<FlSpot> expectedWeightSpots = const [
    FlSpot(0, 55),
    FlSpot(1, 54.2),
    FlSpot(2, 53.3),
    FlSpot(3, 52.5),
    FlSpot(4, 51.6),
    FlSpot(5, 50.8),
    FlSpot(6, 50),
  ];

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

  List<FlSpot> _animatedSpots(
      List<FlSpot> spots,
      double value,
      ) {
    final startY = spots.first.y;

    return spots.map((spot) {
      return FlSpot(
        spot.x,
        startY + ((spot.y - startY) * value),
      );
    }).toList();
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
    return LineChartData(
      minX: -0.75,
      maxX: 6.75,

      minY: 48,
      maxY: 56,

      clipData: const FlClipData.all(),

      borderData: FlBorderData(
        show: false,
      ),

      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 2,
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
            interval: 2,
            getTitlesWidget: (value, meta) {
              if (value == 48) {
                return const SizedBox.shrink();
              }

              if (value != 50 &&
                  value != 52 &&
                  value != 54 &&
                  value != 56) {
                return const SizedBox.shrink();
              }

              return SideTitleWidget(
                meta: meta,
                space: 3,
                child: Text(
                  value.toInt().toString(),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors
                        .planTrackingSecondaryLabel,
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
              String day = '';
              String month = '';

              if ((value - 0).abs() < 0.01) {
                day = '14';
                month = context.l10n.april;
              } else if ((value - 2).abs() < 0.01) {
                day = '20';
                month = context.l10n.may;
              } else if ((value - 4).abs() < 0.01) {
                day = '18';
                month = context.l10n.june;
              } else if ((value - 6).abs() < 0.01) {
                day = '20';
                month = context.l10n.july;
              } else {
                return const SizedBox.shrink();
              }

              return SideTitleWidget(
                meta: meta,
                space: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      day,
                      style:
                      AppTextStyles.labelSmall.copyWith(
                        color: AppColors
                            .planTrackingSecondaryLabel,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),

                    const SizedBox(height: 1),

                    Text(
                      month,
                      style:
                      AppTextStyles.caption.copyWith(
                        color: AppColors
                            .planTrackingSecondaryLabel,
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
                '${spot.y.toStringAsFixed(1)} kg',
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
              return spot.x == 6;
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

        // GERÇEK İLERLEME
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
            y: 50,
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
              labelResolver: (_) => '50 kg',
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