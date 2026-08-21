import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';

class PlanWeightSummaryCard extends StatelessWidget {
  final double startWeight;
  final String startDate;

  final int reachDay;
  final String reachMonth;

  // true  -> olumlu değişim
  // false -> olumsuz değişim
  // null  -> değişiklik yok
  final bool? isProjectionGood;

  final double goalWeight;

  const PlanWeightSummaryCard({
    super.key,
    required this.startWeight,
    required this.startDate,
    required this.reachDay,
    required this.reachMonth,
    required this.isProjectionGood,
    required this.goalWeight,
  });

  String _formatWeight(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final Color projectionColor;

    if (isProjectionGood == true) {
      projectionColor = AppColors.authButtonGreen;
    } else if (isProjectionGood == false) {
      projectionColor = AppColors.red;
    } else {
      // Tarihte değişiklik yok.
      projectionColor = AppColors.homeBrown;
    }

    return Container(
      width: double.infinity,
      height: 132,
      padding: const EdgeInsets.fromLTRB(
        12,
        14,
        8,
        12,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _WeightColumn(
              title: context.l10n.startWeight,
              weight: _formatWeight(startWeight),
              bottomText: startDate,
            ),
          ),

          const _Divider(),

          Expanded(
            child: _GoalDateColumn(
              title: context.l10n.goalReachDate,
              reachDay: reachDay,
              reachMonth: reachMonth,
              isProjectionGood: isProjectionGood,
              projectionColor: projectionColor,
            ),
          ),

          const _Divider(),

          Expanded(
            child: _WeightColumn(
              title: context.l10n.goalWeight,
              weight: _formatWeight(goalWeight),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeightColumn extends StatelessWidget {
  final String title;
  final String weight;
  final String? bottomText;

  const _WeightColumn({
    required this.title,
    required this.weight,
    this.bottomText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 20,
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.planTrackingLabel,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
          ),
        ),

        const SizedBox(height: 14),

        SizedBox(
          height: 30,
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    weight,
                    style:
                    AppTextStyles.headingMedium.copyWith(
                      color: AppColors.homeBrown,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),

                  const SizedBox(width: 3),

                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 2,
                    ),
                    child: Text(
                      'kg',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors
                            .planTrackingSecondaryLabel,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        height: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 11),

        SizedBox(
          height: 17,
          child: bottomText != null
              ? Center(
            child: Text(
              bottomText!,
              textAlign: TextAlign.center,
              style:
              AppTextStyles.caption.copyWith(
                color: AppColors
                    .planTrackingSecondaryLabel,
                fontSize: 10,
                fontWeight: FontWeight.w500,
                height: 1,
              ),
            ),
          )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _GoalDateColumn extends StatelessWidget {
  final String title;
  final int reachDay;
  final String reachMonth;

  // true  -> yeşil + yukarı ok
  // false -> kırmızı + aşağı ok
  // null  -> kahverengi + ikon yok
  final bool? isProjectionGood;

  final Color projectionColor;

  const _GoalDateColumn({
    required this.title,
    required this.reachDay,
    required this.reachMonth,
    required this.isProjectionGood,
    required this.projectionColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 20,
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.planTrackingLabel,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
          ),
        ),

        const SizedBox(height: 14),

        SizedBox(
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                reachDay.toString(),
                style: AppTextStyles.titleLarge.copyWith(
                  color: projectionColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),

              // Sadece olumlu veya olumsuz
              // değişim varsa ikon gösteriyoruz.
              if (isProjectionGood != null) ...[
                const SizedBox(width: 4),

                Icon(
                  isProjectionGood!
                      ? Icons.trending_up_rounded
                      : Icons.trending_down_rounded,
                  color: projectionColor,
                  size: 24,
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 8),

        Text(
          reachMonth,
          textAlign: TextAlign.center,
          style: AppTextStyles.labelMedium.copyWith(
            color: projectionColor,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 40,
      ),
      child: Container(
        width: 1,
        height: 40,
        color:
        AppColors.planTrackingSecondaryLabel.withValues(
          alpha: 0.32,
        ),
      ),
    );
  }
}