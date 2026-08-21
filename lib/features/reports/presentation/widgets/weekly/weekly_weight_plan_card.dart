import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/features/reports/models/weekly_report_data.dart';

class WeeklyWeightPlanCard extends StatelessWidget {
  final WeeklyWeightPlanData data;

  const WeeklyWeightPlanCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final change =
        data.currentWeight - data.lastWeekWeight;

    final lostWeight = change < 0;

    final unchanged =
        change.abs() < 0.01;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        22,
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
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          // =====================================================
          // WEIGHT
          // =====================================================

          Row(
            children: [
              Expanded(
                child: _WeightValue(
                  value:
                  '${data.lastWeekWeight.toStringAsFixed(1)} kg',
                  label: 'Geçen Hafta',
                ),
              ),

              Expanded(
                child: _WeightValue(
                  value:
                  '${data.currentWeight.toStringAsFixed(1)} kg',
                  label: 'Şimdi',
                  alignRight: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 19),

          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!unchanged)
                  Icon(
                    lostWeight
                        ? Icons.arrow_downward_rounded
                        : Icons.arrow_upward_rounded,
                    size: 19,
                    color: lostWeight
                        ? AppColors.calendarCompleted
                        : AppColors.red,
                  ),

                if (!unchanged)
                  const SizedBox(width: 4),

                Text(
                  '${change.abs().toStringAsFixed(1)} kg',
                  style:
                  AppTextStyles.titleMedium.copyWith(
                    color: AppColors.homeBrown,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // =====================================================
          // STATUS
          // =====================================================

          Row(
            crossAxisAlignment:
            CrossAxisAlignment.center,
            children: [
              Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                  color: AppColors.calendarCompleted,
                  shape: BoxShape.circle,
                ),
              ),

              const SizedBox(width: 9),

              Expanded(
                child: Text(
                  data.statusLabel,
                  style:
                  AppTextStyles.titleMedium.copyWith(
                    color: AppColors.homeBrown,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 13),

          Text(
            data.statusDescription,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.homeBrown,
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeightValue extends StatelessWidget {
  final String value;
  final String label;
  final bool alignRight;

  const _WeightValue({
    required this.value,
    required this.label,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.homeBrown,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 3),

        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
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