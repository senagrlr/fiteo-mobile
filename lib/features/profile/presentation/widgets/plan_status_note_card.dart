import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/plan_status.dart';

class PlanStatusNoteCard extends StatelessWidget {
  final PlanStatus status;
  final String estimatedGoalDate;
  final VoidCallback? onReviewPlan;

  const PlanStatusNoteCard({
    super.key,
    required this.status,
    required this.estimatedGoalDate,
    this.onReviewPlan,
  });

  String _description(BuildContext context) {
    switch (status) {
      case PlanStatus.onTrack:
        return context.l10n.onTrackPlanNoteWithDate(
          estimatedGoalDate,
        );

      case PlanStatus.reviewRecommended:
        return context.l10n.reviewRecommendedPlanNote;

      case PlanStatus.notEnoughData:
        return context.l10n.notEnoughDataPlanNote;

      case PlanStatus.improveConsistencyFirst:
        return context.l10n.improveConsistencyPlanNote;
    }
  }

  @override
  Widget build(BuildContext context) {
    final showButton =
        status == PlanStatus.reviewRecommended;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(
              minHeight: 125,
            ),
            padding: const EdgeInsets.fromLTRB(
              20,
              28,
              20,
              20,
            ),
            decoration: BoxDecoration(
              color:
              AppColors.planTrackingNoteBackground,
              borderRadius: BorderRadius.circular(22),
              boxShadow: const [
                BoxShadow(
                  color:
                  AppColors.calendarSummaryShadow,
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
                  _description(context),
                  style:
                  AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.onPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),

                if (showButton) ...[
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: onReviewPlan,
                      style:
                      ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor:
                        AppColors.surfacePrimary,
                        foregroundColor:
                        AppColors.homeBrown,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        context.l10n.reviewNewPlan,
                        style: AppTextStyles
                            .labelMedium
                            .copyWith(
                          color: AppColors.homeBrown,
                          fontSize: 15,
                          fontWeight:
                          FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          Positioned(
            top: -12,
            left: 20,
            child: const Icon(
              Icons.attach_file_rounded,
              color:
              AppColors.planTrackingLabel,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}