import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/features/reports/models/weekly_report_data.dart';

class WeeklyOverviewCard extends StatelessWidget {
  final WeeklyOverviewData data;

  const WeeklyOverviewCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        16,
        20,
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
          Text(
            context.l10n.yourWeek,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.calendarCompleted,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 16),

          _OverviewRow(
            label: context.l10n.calories,
            value: data.caloriesStatus,
          ),

          _OverviewRow(
            label: context.l10n.protein,
            value: data.proteinStatus,
          ),

          _OverviewRow(
            label: context.l10n.carbs,
            value: data.carbsStatus,
          ),

          _OverviewRow(
            label: context.l10n.fat,
            value: data.fatStatus,
          ),

          _OverviewRow(
            label: context.l10n.hydration,
            value: data.hydrationStatus,
          ),

          _OverviewRow(
            label: context.l10n.activity,
            value: data.activityStatus,
            bottomPadding: 0,
          ),
        ],
      ),
    );
  }
}

class _OverviewRow extends StatelessWidget {
  final String label;
  final String value;
  final double bottomPadding;

  const _OverviewRow({
    required this.label,
    required this.value,
    this.bottomPadding = 7,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: bottomPadding,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.homeBrown,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          const SizedBox(width: 14),

          Text(
            value,
            textAlign: TextAlign.right,
            style: AppTextStyles.bodySmall.copyWith(
              color:
              AppColors.planTrackingSecondaryLabel,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}