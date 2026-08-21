import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';

class UniqueFeaturesCard extends StatelessWidget {
  final int longestStreak;
  final int bestProtein;
  final String mostActiveDay;

  const UniqueFeaturesCard({
    super.key,
    required this.longestStreak,
    required this.bestProtein,
    required this.mostActiveDay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 215,
      padding: const EdgeInsets.fromLTRB(
        18,
        18,
        18,
        16,
      ),
      decoration: BoxDecoration(
        color: AppColors.calendarSummaryCardBackground,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.yourUniqueFeatures,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.planTrackingLabel,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _UniqueFeatureItem(
                    badgeColor:
                    AppColors.planTrackingStreakBadge,
                    badgeText: longestStreak.toString(),
                    label: context.l10n.longestStreak,
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 30,
                    ),
                    child: _UniqueFeatureItem(
                      badgeColor:
                      AppColors.planTrackingProteinBadge,
                      badgeText: '${bestProtein}g',
                      label: context.l10n.bestProtein,
                    ),
                  ),
                ),

                Expanded(
                  child: _UniqueFeatureItem(
                    badgeColor:
                    AppColors.planTrackingActiveDayBadge,
                    badgeText: mostActiveDay,
                    label: context.l10n.mostActiveDay,
                    fitBadgeText: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UniqueFeatureItem extends StatelessWidget {
  final Color badgeColor;
  final String badgeText;
  final String label;
  final bool fitBadgeText;

  const _UniqueFeatureItem({
    required this.badgeColor,
    required this.badgeText,
    required this.label,
    this.fitBadgeText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipPath(
          clipper: _HexagonClipper(),
          child: Container(
            width: 60,
            height: 66,
            color: badgeColor,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
            ),
            child: fitBadgeText
                ? FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                badgeText,
                maxLines: 1,
                style:
                AppTextStyles.labelMedium.copyWith(
                  color: AppColors.onPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            )
                : Text(
              badgeText,
              style:
              AppTextStyles.labelMedium.copyWith(
                color: AppColors.onPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),

        const SizedBox(height: 9),

        Text(
          label,
          maxLines: 2,
          textAlign: TextAlign.center,
          style: AppTextStyles.labelSmall.copyWith(
            color:
            AppColors.planTrackingSecondaryLabel,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}

class _HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(
      size.width * 0.5,
      0,
    );

    path.lineTo(
      size.width,
      size.height * 0.24,
    );

    path.lineTo(
      size.width,
      size.height * 0.76,
    );

    path.lineTo(
      size.width * 0.5,
      size.height,
    );

    path.lineTo(
      0,
      size.height * 0.76,
    );

    path.lineTo(
      0,
      size.height * 0.24,
    );

    path.close();

    return path;
  }

  @override
  bool shouldReclip(
      covariant CustomClipper<Path> oldClipper,
      ) {
    return false;
  }
}