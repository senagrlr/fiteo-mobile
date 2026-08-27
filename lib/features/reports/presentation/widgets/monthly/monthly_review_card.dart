import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/features/reports/models/monthly_report_data.dart';

class MonthlyReviewCard extends StatelessWidget {
  final List<String> paragraphs;

  const MonthlyReviewCard({
    super.key,
    required this.paragraphs,
  });

  @override
  Widget build(BuildContext context) {
    if (paragraphs.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        21,
      ),
      decoration: BoxDecoration(
        color: AppColors.calendarCompleted
            .withValues(alpha: 0.11),
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

          Row(
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                color:
                AppColors.calendarCompleted,
                size: 20,
              ),

              const SizedBox(width: 9),

              Expanded(
                child: Text(
                  context.l10n.yourMonthInReview
                      .toUpperCase(),
                  style: AppTextStyles
                      .titleMedium
                      .copyWith(
                    color: AppColors.homeBrown,
                    fontSize: 15,
                    fontWeight:
                    FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          if (paragraphs.isNotEmpty) ...[
            const SizedBox(height: 17),

            ...paragraphs.asMap().entries.map(
                  (entry) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom:
                    entry.key ==
                        paragraphs.length - 1
                        ? 0
                        : 14,
                  ),
                  child: Text(
                    entry.value,
                    style: AppTextStyles
                        .bodyMedium
                        .copyWith(
                      color: AppColors.homeBrown,
                      fontSize: 14,
                      height: 1.55,
                      fontWeight:
                      FontWeight.w500,
                    ),
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