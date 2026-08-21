import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/features/reports/models/weekly_report_data.dart';

class WeeklyNextWeekCard extends StatelessWidget {
  final WeeklyNextWeekData data;

  const WeeklyNextWeekCard({
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =====================================================
          // GELECEK HAFTA PLANI
          // =====================================================

          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.homeCardBackground,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.track_changes_rounded,
                  color: AppColors.calendarCompleted,
                  size: 21,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  context.l10n.nextWeekPlan,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.homeBrown,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            data.focusDescription,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.homeBrown,
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),

          // =====================================================
          // BUNU DENE
          // =====================================================

          if (data.tips.isNotEmpty) ...[
            const SizedBox(height: 24),

            Text(
              context.l10n.tryThis.toUpperCase(),
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.calendarCompleted,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 15),

            ...List.generate(
              data.tips.length,
                  (index) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom:
                    index == data.tips.length - 1
                        ? 0
                        : 16,
                  ),
                  child: _TipRow(
                    number: index + 1,
                    text: data.tips[index],
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _TipRow extends StatelessWidget {
  final int number;
  final String text;

  const _TipRow({
    required this.number,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.calendarCompleted.withValues(
              alpha: 0.14,
            ),
            shape: BoxShape.circle,
          ),
          child: Text(
            number.toString().padLeft(2, '0'),
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.calendarCompleted,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 3,
            ),
            child: Text(
              text,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.homeBrown,
                fontSize: 14,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}