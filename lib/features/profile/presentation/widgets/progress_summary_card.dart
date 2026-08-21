import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/progress_models.dart';

class ProgressSummaryCard extends StatelessWidget {
  final ProgressSummaryData data;

  const ProgressSummaryCard({
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.dateRange,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.planTrackingSecondaryLabel,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 18),

          // ANA DEĞER
          _SummaryItem(
            item: data.primaryItem,
          ),

          const SizedBox(height: 22),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _SummaryItem(
                  item: data.bottomLeftItem,
                ),
              ),

              const SizedBox(width: 20),

              Expanded(
                child: _SummaryItem(
                  item: data.bottomRightItem,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final ProgressSummaryItem item;

  const _SummaryItem({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.value,
          maxLines: 1,
          style: AppTextStyles.headingMedium.copyWith(
            color: AppColors.homeBrown,

            // Tüm değerler artık aynı boyutta.
            fontSize: 27,

            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),

        const SizedBox(height: 6),

        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            item.label,
            maxLines: 1,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.planTrackingSecondaryLabel,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}