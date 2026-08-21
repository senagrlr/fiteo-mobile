import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';

class ReportScoreSection extends StatelessWidget {
  final int score;
  final int change;
  final String scoreLabel;
  final String changeLabel;

  const ReportScoreSection({
    super.key,
    required this.score,
    required this.change,
    required this.scoreLabel,
    required this.changeLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = change >= 0;

    final changeColor = isPositive
        ? AppColors.calendarCompleted
        : AppColors.red;

    return Column(
      children: [
        Text(
          '%$score',
          style: AppTextStyles.headingLarge.copyWith(
            color: AppColors.homeBrown,
            fontSize: 45,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          scoreLabel.toUpperCase(),
          textAlign: TextAlign.center,
          style: AppTextStyles.labelSmall.copyWith(
            color:
            AppColors.planTrackingSecondaryLabel,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isPositive
                  ? Icons.arrow_upward_rounded
                  : Icons.arrow_downward_rounded,
              color: changeColor,
              size: 16,
            ),

            const SizedBox(width: 3),

            Text(
              changeLabel,
              style: AppTextStyles.bodySmall.copyWith(
                color: changeColor,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ],
    );
  }
}