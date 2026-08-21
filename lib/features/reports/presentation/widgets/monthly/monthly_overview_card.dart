import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/features/reports/models/monthly_report_data.dart';

class MonthlyOverviewCard extends StatelessWidget {
  final MonthlyOverviewData data;

  const MonthlyOverviewCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        17,
        20,
        19,
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
          Center(
            child: Text(
              context.l10n.whatChangedThisMonth,
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.calendarCompleted,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),

          const SizedBox(height: 20),

          ...data.changes.asMap().entries.map(
                (entry) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom:
                  entry.key ==
                      data.changes.length - 1
                      ? 0
                      : 10,
                ),
                child: _ChangeRow(
                  item: entry.value,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ChangeRow extends StatelessWidget {
  final MonthlyChangeItem item;

  const _ChangeRow({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    switch (item.direction) {
      case MonthlyChangeDirection.up:
        icon = Icons.arrow_upward_rounded;
        color = AppColors.calendarCompleted;

      case MonthlyChangeDirection.down:
        icon = Icons.arrow_downward_rounded;
        color = AppColors.red;

      case MonthlyChangeDirection.same:
        icon = Icons.horizontal_rule_rounded;
        color =
            AppColors.planTrackingSecondaryLabel;
    }

    return Row(
      children: [
        Expanded(
          child: Text(
            item.label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.homeBrown,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        const SizedBox(width: 12),

        Icon(
          icon,
          size: 16,
          color: color,
        ),

        const SizedBox(width: 5),

        SizedBox(
          width: 64,
          child: Text(
            item.value,
            textAlign: TextAlign.right,
            style: AppTextStyles.bodySmall.copyWith(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}