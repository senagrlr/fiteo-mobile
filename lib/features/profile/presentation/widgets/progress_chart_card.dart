import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/progress_models.dart';

class ProgressChartCard extends StatelessWidget {
  final ProgressChartData data;

  final ProgressRange selectedRange;
  final List<ProgressRange> availableRanges;
  final ValueChanged<ProgressRange> onRangeChanged;

  const ProgressChartCard({
    super.key,
    required this.data,
    required this.selectedRange,
    required this.availableRanges,
    required this.onRangeChanged,
  });

  String _rangeLabel(
      BuildContext context,
      ProgressRange range,
      ) {
    switch (range) {
      case ProgressRange.days7:
        return context.l10n.days7;

      case ProgressRange.days30:
        return context.l10n.days30;

      case ProgressRange.days90:
        return context.l10n.days90;

      case ProgressRange.days365:
        return context.l10n.days365;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        14,
        14,
        14,
        18,
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
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: PopupMenuButton<ProgressRange>(
              onSelected: onRangeChanged,
              color: AppColors.surfacePrimary,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              itemBuilder: (context) {
                return availableRanges.map((range) {
                  return PopupMenuItem<ProgressRange>(
                    value: range,
                    child: Text(
                      _rangeLabel(
                        context,
                        range,
                      ),
                      style:
                      AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.homeBrown,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSoft,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _rangeLabel(
                        context,
                        selectedRange,
                      ),
                      style:
                      AppTextStyles.labelSmall.copyWith(
                        color: AppColors
                            .planTrackingSecondaryLabel,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(width: 3),

                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color:
                      AppColors.planTrackingSecondaryLabel,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Grafik artık daha uzun.
          SizedBox(
            height: 250,
            child: LineChart(
              _chartData(context),
              duration: const Duration(
                milliseconds: 300,
              ),
              curve: Curves.easeOut,
            ),
          ),
        ],
      ),
    );
  }

  LineChartData _chartData(
      BuildContext context,
      ) {
    return LineChartData(
      minX: 0,
      maxX: (data.spots.length - 1).toDouble(),

      minY: data.minY,
      maxY: data.maxY,

      clipData: const FlClipData.all(),

      borderData: FlBorderData(
        show: false,
      ),

      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: data.interval,
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
            reservedSize: 30,
            interval: data.interval,
            getTitlesWidget: (value, meta) {
              return SideTitleWidget(
                meta: meta,
                space: 5,
                child: Text(
                  _formatAxisValue(value),
                  style:
                  AppTextStyles.caption.copyWith(
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
            reservedSize: 32,
            interval: 1,
            getTitlesWidget: (value, meta) {
              final rounded = value.round();

              if ((value - rounded).abs() > 0.01) {
                return const SizedBox.shrink();
              }

              if (rounded < 0 ||
                  rounded >= data.bottomLabels.length) {
                return const SizedBox.shrink();
              }

              final label =
              data.bottomLabels[rounded];

              if (label.isEmpty) {
                return const SizedBox.shrink();
              }

              return SideTitleWidget(
                meta: meta,
                space: 6,
                child: Text(
                  label,
                  style:
                  AppTextStyles.caption.copyWith(
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
      ),

      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData:
        LineTouchTooltipData(
          getTooltipItems: (spots) {
            return spots.map((spot) {
              return LineTooltipItem(
                '${_formatTooltipValue(spot.y)} '
                    '${data.tooltipUnit}',
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

      extraLinesData: ExtraLinesData(
        horizontalLines: [
          HorizontalLine(
            y: data.targetY,
            color: data.lineColor.withValues(
              alpha: 0.35,
            ),
            strokeWidth: 1.5,
            dashArray: [6, 5],
          ),
        ],
      ),

      lineBarsData: [
        LineChartBarData(
          spots: data.spots,
          isCurved: true,
          curveSmoothness: 0.28,
          color: data.lineColor,
          barWidth: 3,
          isStrokeCapRound: true,

          belowBarData: BarAreaData(
            show: true,
            color: data.lineColor.withValues(
              alpha: 0.055,
            ),
          ),

          // Her veri noktası görünüyor.
          dotData: FlDotData(
            show: true,
            getDotPainter: (
                spot,
                percent,
                barData,
                index,
                ) {
              return FlDotCirclePainter(
                radius: 3.5,
                color: AppColors.surfacePrimary,
                strokeWidth: 2,
                strokeColor: data.lineColor,
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatAxisValue(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(1);
  }

  String _formatTooltipValue(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(1);
  }
}