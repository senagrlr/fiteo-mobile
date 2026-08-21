import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/features/reports/models/monthly_report_data.dart';

class MonthlyConsistencyCard
    extends StatelessWidget {
  final MonthlyConsistencyData data;

  const MonthlyConsistencyCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        21,
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
          Text(
            context.l10n.consistency,
            style:
            AppTextStyles.titleMedium.copyWith(
              color: AppColors.calendarCompleted,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 20),

          _ConsistencyRow(
            value:
            '%${data.trackingConsistency}',
            title:
            context.l10n.trackingConsistency,
            description:
            '${data.trackedDays}/${data.totalDays} ${context.l10n.daysTracked}',
          ),

          const SizedBox(height: 18),

          _ConsistencyRow(
            value:
            '%${data.goalConsistency}',
            title:
            context.l10n.goalConsistency,
            description:
            data.goalConsistencyNote,
          ),

          const SizedBox(height: 22),

          Container(
            height: 1,
            color: AppColors.mealFieldDivider,
          ),

          const SizedBox(height: 19),

          Row(
            children: [
              Expanded(
                child: _SmallConsistencyMetric(
                  value:
                  '${data.longestStreakDays}',
                  label:
                  context.l10n.longestStreak,
                ),
              ),

              Container(
                width: 1,
                height: 44,
                color:
                AppColors.mealFieldDivider,
              ),

              Expanded(
                child: _SmallConsistencyMetric(
                  value:
                  '${data.perfectDays}',
                  label:
                  context.l10n.perfectDays,
                  tooltip:
                  context.l10n
                      .perfectDayDefinition,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConsistencyRow extends StatelessWidget {
  final String value;
  final String title;
  final String description;

  const _ConsistencyRow({
    required this.value,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 70,
          child: Text(
            value,
            style:
            AppTextStyles.headingLarge.copyWith(
              color: AppColors.homeBrown,
              fontSize: 27,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        const SizedBox(width: 9),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.homeBrown,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                description,
                style:
                AppTextStyles.bodySmall.copyWith(
                  color: AppColors
                      .planTrackingSecondaryLabel,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SmallConsistencyMetric
    extends StatelessWidget {
  final String value;
  final String label;
  final String? tooltip;

  const _SmallConsistencyMetric({
    required this.value,
    required this.label,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style:
          AppTextStyles.titleMedium.copyWith(
            color: AppColors.homeBrown,
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 3),

        Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style:
                AppTextStyles.bodySmall.copyWith(
                  color: AppColors
                      .planTrackingSecondaryLabel,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}