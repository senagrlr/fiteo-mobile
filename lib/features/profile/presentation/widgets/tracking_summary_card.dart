import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';

class TrackingSummaryCard extends StatelessWidget {
  final int trackingConsistency;
  final int goalAchievement;

  const TrackingSummaryCard({
    super.key,
    required this.trackingConsistency,
    required this.goalAchievement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TrackingValueCard(
            title: context.l10n.trackingConsistency,
            child: Text(
              '%$trackingConsistency',
              style: AppTextStyles.headingLarge.copyWith(
                color: AppColors.homeBrown,
                fontSize: 30,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: _TrackingValueCard(
            title: context.l10n.goalAchievement,
            child: Text(
              '%$goalAchievement',
              style:
              AppTextStyles.headingLarge.copyWith(
                color: AppColors.homeBrown,
                fontSize: 30,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TrackingValueCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _TrackingValueCard({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105,
      padding: const EdgeInsets.fromLTRB(
        12,
        17,
        12,
        17,
      ),
      decoration: BoxDecoration(
        color:
        AppColors.calendarSummaryCardBackground,
        borderRadius: BorderRadius.circular(26),
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
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style:
            AppTextStyles.bodyMedium.copyWith(
              color: AppColors.planTrackingLabel,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),

          const Spacer(),

          child,
        ],
      ),
    );
  }
}