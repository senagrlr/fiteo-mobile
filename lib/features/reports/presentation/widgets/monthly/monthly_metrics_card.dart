import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/features/reports/models/monthly_report_data.dart';

class MonthlyMetricsCard extends StatelessWidget {
  final MonthlyMetricsData data;

  const MonthlyMetricsCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        12,
        16,
        12,
        17,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _MetricColumn(
              title: context.l10n.calories,
              value: data.caloriesAverage,
              subtitle: context.l10n.dailyAverage,
              targetText: data.caloriesTargetDays,
            ),
          ),

          _divider(),

          Expanded(
            child: _MetricColumn(
              title: context.l10n.activity,
              value: data.activeDays,
              subtitle: context.l10n.active,
              targetText: data.workoutTime,
            ),
          ),

          _divider(),

          Expanded(
            child: _MetricColumn(
              title: context.l10n.protein,
              value: data.proteinAverage,
              subtitle: context.l10n.dailyAverage,
              targetText: data.proteinTargetDays,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 54,
      margin: const EdgeInsets.only(
        top: 22,
        left: 7,
        right: 7,
      ),
      color: AppColors.mealFieldDivider,
    );
  }
}

class _MetricColumn extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final String targetText;

  const _MetricColumn({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.targetText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.calendarCompleted,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 11),

        Text(
          value,
          textAlign: TextAlign.center,
          maxLines: 1,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.homeBrown,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 2),

        Text(
          subtitle,
          textAlign: TextAlign.center,
          maxLines: 1,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.homeBrown,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          targetText,
          textAlign: TextAlign.center,
          maxLines: 1,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.planTrackingSecondaryLabel,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}