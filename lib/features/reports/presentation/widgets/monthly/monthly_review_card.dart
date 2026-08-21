import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/features/reports/models/monthly_report_data.dart';

class MonthlyReviewCard extends StatelessWidget {
  final List<String> paragraphs;
  final List<MonthlyPatternData> patterns;

  const MonthlyReviewCard({
    super.key,
    required this.paragraphs,
    required this.patterns,
  });

  @override
  Widget build(BuildContext context) {
    if (paragraphs.isEmpty && patterns.isEmpty) {
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
          // =====================================================
          // MONTHLY REVIEW TITLE
          // =====================================================

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

          // =====================================================
          // REVIEW TEXT
          // =====================================================

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

          // =====================================================
          // PATTERNS WE NOTICED
          // =====================================================

          if (patterns.isNotEmpty) ...[
            const SizedBox(height: 23),

            Container(
              height: 1,
              width: double.infinity,
              color: AppColors.mealFieldDivider,
            ),

            const SizedBox(height: 19),

            Text(
              context.l10n.patternsWeNoticed
                  .toUpperCase(),
              style: AppTextStyles
                  .labelMedium
                  .copyWith(
                color:
                AppColors.calendarCompleted,
                fontSize: 13,
                fontWeight:
                FontWeight.w900,
              ),
            ),

            const SizedBox(height: 16),

            ...patterns.asMap().entries.map(
                  (entry) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom:
                    entry.key ==
                        patterns.length - 1
                        ? 0
                        : 18,
                  ),
                  child: _PatternItem(
                    data: entry.value,
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

class _PatternItem extends StatelessWidget {
  final MonthlyPatternData data;

  const _PatternItem({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Container(
          width: 7,
          height: 7,
          margin: const EdgeInsets.only(
            top: 6,
          ),
          decoration: const BoxDecoration(
            color: AppColors.calendarCompleted,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                data.title.toUpperCase(),
                style: AppTextStyles
                    .labelMedium
                    .copyWith(
                  color: AppColors.homeBrown,
                  fontSize: 12,
                  fontWeight:
                  FontWeight.w800,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                data.description,
                style: AppTextStyles
                    .bodyMedium
                    .copyWith(
                  color: AppColors.homeBrown,
                  fontSize: 14,
                  height: 1.5,
                  fontWeight:
                  FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}