import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';

class PlanComparisonChart extends StatefulWidget {
  const PlanComparisonChart({
    super.key,
  });

  @override
  State<PlanComparisonChart> createState() {
    return _PlanComparisonChartState();
  }
}

class _PlanComparisonChartState extends State<PlanComparisonChart>
    with SingleTickerProviderStateMixin {
  static const Color _genericPlanColor = Color(0xFFD5D7D0);

  late final AnimationController _animationController;
  late final Animation<double> _animation;

  final List<FlSpot> _fiteoFinalSpots = const [
    FlSpot(0, 0),
    FlSpot(1, 14),
    FlSpot(2, 31),
    FlSpot(3, 50),
    FlSpot(4, 69),
    FlSpot(5, 86),
    FlSpot(6, 100),
  ];

  final List<FlSpot> _genericFinalSpots = const [
    FlSpot(0, 0),
    FlSpot(1, 24),
    FlSpot(2, 43),
    FlSpot(3, 54),
    FlSpot(4, 59),
    FlSpot(5, 61),
    FlSpot(6, 62),
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1900),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _animationController.forward(from: 0);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<FlSpot> _animatedSpots(
      List<FlSpot> finalSpots,
      double animationValue,
      ) {
    return finalSpots.map((spot) {
      return FlSpot(
        spot.x,
        spot.y * animationValue,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 290,
      padding: const EdgeInsets.fromLTRB(
        18,
        18,
        18,
        16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.authText.withValues(
              alpha: 0.06,
            ),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your progress over time',
            style: TextStyle(
              color: AppColors.authText,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 11),

          const Row(
            children: [
              _LegendItem(
                label: 'Fiteo plan',
                color: AppColors.authButtonGreen,
              ),
              SizedBox(width: 18),
              _LegendItem(
                label: 'Generic plan',
                color: _genericPlanColor,
              ),
            ],
          ),

          const SizedBox(height: 12),

          Expanded(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return LineChart(
                  _chartData(_animation.value),
                  duration: Duration.zero,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  LineChartData _chartData(double animationValue) {
    return LineChartData(
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 100,

      clipData: const FlClipData.all(),

      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 25,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: AppColors.authText.withValues(
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
            reservedSize: 44,
            interval: 25,
            getTitlesWidget: (value, meta) {
              if (value != 25 &&
                  value != 50 &&
                  value != 75 &&
                  value != 100) {
                return const SizedBox.shrink();
              }

              return SideTitleWidget(
                meta: meta,
                space: 8,
                child: Text(
                  '${value.toInt()}%',
                  style: TextStyle(
                    color: AppColors.authText.withValues(
                      alpha: 0.48,
                    ),
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
            reservedSize: 24,
            interval: 1,
            getTitlesWidget: (value, meta) {
              String text = '';

              switch (value.toInt()) {
                case 0:
                  text = 'Start';
                  break;
                case 2:
                  text = 'Early';
                  break;
                case 4:
                  text = 'Mid';
                  break;
                case 6:
                  text = 'Goal';
                  break;
              }

              if (text.isEmpty) {
                return const SizedBox.shrink();
              }

              return SideTitleWidget(
                meta: meta,
                space: 7,
                child: Text(
                  text,
                  style: TextStyle(
                    color: AppColors.authText.withValues(
                      alpha: 0.50,
                    ),
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ),
      ),

      borderData: FlBorderData(
        show: false,
      ),

      lineTouchData: const LineTouchData(
        enabled: false,
      ),

      lineBarsData: [
        _genericPlanLine(animationValue),
        _fiteoPlanLine(animationValue),
      ],

      extraLinesData: ExtraLinesData(
        horizontalLines: [
          HorizontalLine(
            y: 100,
            color: AppColors.red.withValues(
              alpha: 0.35,
            ),
            strokeWidth: 1,
            dashArray: [5, 5],
            label: HorizontalLineLabel(
              show: animationValue > 0.85,
              alignment: Alignment.topRight,
              padding: const EdgeInsets.only(
                right: 4,
                bottom: 5,
              ),
              style: const TextStyle(
                color: AppColors.red,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
              labelResolver: (_) => 'Your goal',
            ),
          ),
        ],
      ),
    );
  }

  LineChartBarData _genericPlanLine(
      double animationValue,
      ) {
    return LineChartBarData(
      spots: _animatedSpots(
        _genericFinalSpots,
        animationValue,
      ),
      isCurved: true,
      curveSmoothness: 0.32,
      color: _genericPlanColor,
      barWidth: 4,
      isStrokeCapRound: true,
      isStrokeJoinRound: true,
      dotData: FlDotData(
        show: animationValue > 0.96,
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
            color: Colors.white,
            strokeWidth: 3,
            strokeColor: _genericPlanColor,
          );
        },
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
  }

  LineChartBarData _fiteoPlanLine(
      double animationValue,
      ) {
    return LineChartBarData(
      spots: _animatedSpots(
        _fiteoFinalSpots,
        animationValue,
      ),
      isCurved: true,
      curveSmoothness: 0.30,
      color: AppColors.authButtonGreen,
      barWidth: 5,
      isStrokeCapRound: true,
      isStrokeJoinRound: true,
      dotData: FlDotData(
        show: animationValue > 0.96,
        checkToShowDot: (spot, barData) {
          return spot.x == 0 || spot.x == 6;
        },
        getDotPainter: (
            spot,
            percent,
            barData,
            index,
            ) {
          return FlDotCirclePainter(
            radius: 6,
            color: Colors.white,
            strokeWidth: 3,
            strokeColor: AppColors.authButtonGreen,
          );
        },
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.authButtonGreen.withValues(
              alpha: 0.22 * animationValue,
            ),
            AppColors.authButtonGreen.withValues(
              alpha: 0.02,
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final Color color;

  const _LegendItem({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 19,
          height: 4,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: TextStyle(
            color: AppColors.authText.withValues(
              alpha: 0.66,
            ),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}