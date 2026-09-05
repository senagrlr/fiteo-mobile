import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:fiteo_myapp/features/membership/presentation/widgets/premium_locked/premium_lock_overlay.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/progress_models.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/progress_chart_card.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/progress_summary_card.dart';

class ProgressLockedPreview extends StatelessWidget {
  final ProgressChartData chartData;
  final ProgressSummaryData summaryData;

  final ProgressRange selectedRange;
  final List<ProgressRange> availableRanges;
  final ValueChanged<ProgressRange> onRangeChanged;

  final ProgressNutritionMetric? selectedNutritionMetric;
  final ValueChanged<ProgressNutritionMetric>?
  onNutritionMetricChanged;

  const ProgressLockedPreview({
    super.key,
    required this.chartData,
    required this.summaryData,
    required this.selectedRange,
    required this.availableRanges,
    required this.onRangeChanged,
    this.selectedNutritionMetric,
    this.onNutritionMetricChanged,
  });

  @override
  Widget build(BuildContext context) {
    const lockedAreaTop = 72.0;

    return SizedBox(
      height: 590,
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                ProgressChartCard(
                  data: chartData,
                  selectedRange: selectedRange,
                  availableRanges: availableRanges,
                  onRangeChanged: onRangeChanged,
                  isPremium: false,
                  selectedNutritionMetric:
                  selectedNutritionMetric,
                  onNutritionMetricChanged:
                  onNutritionMetricChanged,
                ),

                const SizedBox(height: 26),

                ProgressSummaryCard(
                  data: summaryData,
                ),
              ],
            ),
          ),

          Positioned(
            top: lockedAreaTop,
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  IgnorePointer(
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 8,
                          sigmaY: 8,
                        ),
                        child: Container(
                          color: const Color(
                            0xFFEEEEEE,
                          ).withValues(
                            alpha: 0.55,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const PremiumLockOverlay(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}