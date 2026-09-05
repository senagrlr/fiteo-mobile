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
  final bool isPremium;

  final ProgressNutritionMetric? selectedNutritionMetric;
  final ValueChanged<ProgressNutritionMetric>?
  onNutritionMetricChanged;

  const ProgressChartCard({
    super.key,
    required this.data,
    required this.selectedRange,
    required this.availableRanges,
    required this.onRangeChanged,
    required this.isPremium,
    this.selectedNutritionMetric,
    this.onNutritionMetricChanged,
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

  String _nutritionLabel(
      BuildContext context,
      ProgressNutritionMetric metric,
      ) {
    switch (metric) {
      case ProgressNutritionMetric.calories:
        return context.l10n.calories;

      case ProgressNutritionMetric.protein:
        return context.l10n.protein;

      case ProgressNutritionMetric.carbs:
        return context.l10n.carbs;

      case ProgressNutritionMetric.fat:
        return context.l10n.fat;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasNutritionSelector =
        selectedNutritionMetric != null &&
            onNutritionMetricChanged != null;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (hasNutritionSelector) ...[
                PopupMenuButton<ProgressNutritionMetric>(
                  onSelected: onNutritionMetricChanged,
                  color: AppColors.surfacePrimary,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(16),
                  ),
                  itemBuilder: (context) {
                    return ProgressNutritionMetric.values
                        .map(
                          (metric) => PopupMenuItem<
                          ProgressNutritionMetric>(
                        value: metric,
                        child: Text(
                          _nutritionLabel(
                            context,
                            metric,
                          ),
                          style: AppTextStyles
                              .bodyMedium
                              .copyWith(
                            color:
                            AppColors.homeBrown,
                            fontSize: 14,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                        .toList();
                  },
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSoft,
                      borderRadius:
                      BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize:
                      MainAxisSize.min,
                      children: [
                        Text(
                          _nutritionLabel(
                            context,
                            selectedNutritionMetric!,
                          ),
                          style: AppTextStyles
                              .labelSmall
                              .copyWith(
                            color:
                            AppColors.homeBrown,
                            fontSize: 11,
                            fontWeight:
                            FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 3),
                        const Icon(
                          Icons
                              .keyboard_arrow_down_rounded,
                          color:
                          AppColors.homeBrown,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 8),
              ],

              PopupMenuButton<ProgressRange>(
                onSelected: onRangeChanged,
                color: AppColors.surfacePrimary,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(16),
                ),
                itemBuilder: (context) {
                  return availableRanges.map(
                        (range) {
                      return PopupMenuItem<
                          ProgressRange>(
                        value: range,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _rangeLabel(
                                  context,
                                  range,
                                ),
                                style: AppTextStyles
                                    .bodyMedium
                                    .copyWith(
                                  color:
                                  AppColors.homeBrown,
                                  fontSize: 14,
                                  fontWeight:
                                  FontWeight.w600,
                                ),
                              ),
                            ),
                            if (!isPremium &&
                                range !=
                                    ProgressRange.days7)
                              const Icon(
                                Icons
                                    .lock_outline_rounded,
                                size: 16,
                                color: AppColors
                                    .planTrackingSecondaryLabel,
                              ),
                          ],
                        ),
                      );
                    },
                  ).toList();
                },
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSoft,
                    borderRadius:
                    BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize:
                    MainAxisSize.min,
                    children: [
                      Text(
                        _rangeLabel(
                          context,
                          selectedRange,
                        ),
                        style: AppTextStyles
                            .labelSmall
                            .copyWith(
                          color: AppColors
                              .planTrackingSecondaryLabel,
                          fontSize: 11,
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 3),
                      const Icon(
                        Icons
                            .keyboard_arrow_down_rounded,
                        color: AppColors
                            .planTrackingSecondaryLabel,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

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
    final chartMinY = data.minY == 0
        ? -data.interval * 0.08
        : data.minY;

    return LineChartData(
      minX: 0,
      maxX:
      (data.bottomLabels.length - 1).toDouble(),

      minY: chartMinY,
      maxY: data.maxY,

      clipData: const FlClipData(
        top: true,
        bottom: false,
        left: true,
        right: true,
      ),

      borderData: FlBorderData(
        show: false,
      ),

      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: data.interval,
        getDrawingHorizontalLine: (value) {
          if (value < 0) {
            return const FlLine(
              color: Colors.transparent,
              strokeWidth: 0,
            );
          }

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
            reservedSize: 44,
            interval: data.interval,
            getTitlesWidget: (value, meta) {
              if (value < 0) {
                return const SizedBox.shrink();
              }

              return SideTitleWidget(
                meta: meta,
                space: 5,
                child: Text(
                  _formatAxisValue(
                    value,
                  ),
                  maxLines: 1,
                  softWrap: false,
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

              if ((value - rounded).abs() >
                  0.01) {
                return const SizedBox.shrink();
              }

              if (rounded < 0 ||
                  rounded >=
                      data.bottomLabels.length) {
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
            final seenX = <double>{};

            return spots.map(
                  (spot) {
                if (!seenX.add(
                  spot.x,
                )) {
                  return null;
                }

                return LineTooltipItem(
                  '${_formatTooltipValue(spot.y)} ${data.tooltipUnit}',
                  AppTextStyles.labelSmall
                      .copyWith(
                    color: AppColors.onPrimary,
                    fontSize: 11,
                    fontWeight:
                    FontWeight.w700,
                  ),
                );
              },
            ).toList();
          },
        ),
      ),

      extraLinesData: ExtraLinesData(
        horizontalLines:
        data.targetY == null
            ? []
            : [
          HorizontalLine(
            y: data.targetY!,
            color: data.lineColor
                .withValues(
              alpha: 0.35,
            ),
            strokeWidth: 1.5,
            dashArray: [
              6,
              5,
            ],
          ),
        ],
      ),

      lineBarsData: _buildLineBars(),
    );
  }

  List<LineChartBarData> _buildLineBars() {
    if (data.spots.length <= 1) {
      return [
        _createLineBar(
          data.spots,
          isCurved: false,
        ),
      ];
    }

    final bars = <LineChartBarData>[];

    var currentSpots = <FlSpot>[
      data.spots.first,
    ];

    var currentIsZeroSegment =
    _isZeroSegment(
      data.spots[0],
      data.spots[1],
    );

    for (var i = 1;
    i < data.spots.length;
    i++) {
      final currentSpot = data.spots[i];

      currentSpots.add(
        currentSpot,
      );

      if (i == data.spots.length - 1) {
        bars.add(
          _createLineBar(
            currentSpots,
            isCurved:
            !currentIsZeroSegment,
          ),
        );

        break;
      }

      final nextIsZeroSegment =
      _isZeroSegment(
        currentSpot,
        data.spots[i + 1],
      );

      if (nextIsZeroSegment !=
          currentIsZeroSegment) {
        bars.add(
          _createLineBar(
            currentSpots,
            isCurved:
            !currentIsZeroSegment,
          ),
        );

        currentSpots = [
          currentSpot,
        ];

        currentIsZeroSegment =
            nextIsZeroSegment;
      }
    }

    return bars;
  }

  bool _isZeroSegment(
      FlSpot first,
      FlSpot second,
      ) {
    return first.y == 0 &&
        second.y == 0;
  }

  LineChartBarData _createLineBar(
      List<FlSpot> spots, {
        required bool isCurved,
      }) {
    return LineChartBarData(
      spots: spots,
      isCurved: isCurved,
      curveSmoothness:
      isCurved ? 0.28 : 0,
      color: data.lineColor,
      barWidth: 3,
      isStrokeCapRound: true,

      belowBarData: BarAreaData(
        show: true,
        color: data.lineColor.withValues(
          alpha: 0.055,
        ),
      ),

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
            color:
            AppColors.surfacePrimary,
            strokeWidth: 2,
            strokeColor:
            data.lineColor,
          );
        },
      ),
    );
  }

  String _formatAxisValue(
      double value,
      ) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(1);
  }

  String _formatTooltipValue(
      double value,
      ) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    if (data.tooltipUnit == 'L' &&
        value.abs() < 1) {
      final formatted =
      value.toStringAsFixed(2);

      if (formatted.endsWith('0')) {
        return value.toStringAsFixed(1);
      }

      return formatted;
    }

    return value.toStringAsFixed(1);
  }
}