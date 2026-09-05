import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:fiteo_myapp/features/profile/presentation/models/plan_status.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/plan_tracking_stats.dart';

import 'package:fiteo_myapp/features/profile/presentation/widgets/plan_status_note_card.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/plan_status_note_shimmer.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/plan_weight_progress_chart.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/plan_weight_summary_card.dart';

class PlanTrackingPlanContent
    extends StatelessWidget {
  final PlanTrackingStats stats;
  final bool isAiNoteLoading;
  final VoidCallback? onReviewPlan;

  const PlanTrackingPlanContent({
    super.key,
    required this.stats,
    this.isAiNoteLoading = false,
    this.onReviewPlan,
  });

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
  }

  String _formatShortMonth(
      BuildContext context,
      DateTime date,
      ) {
    final locale =
    Localizations.localeOf(context)
        .toLanguageTag();

    return DateFormat.MMM(
      locale,
    ).format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PlanWeightSummaryCard(
          startWeight:
          stats.planStartWeight,
          startDate:
          _formatDate(
            stats.planActivatedAt,
          ),
          reachDay:
          stats.estimatedGoalDate?.day ?? 0,
          reachMonth:
          stats.estimatedGoalDate == null
              ? '-'
              : _formatShortMonth(
            context,
            stats.estimatedGoalDate!,
          ),
          isProjectionGood:
          stats.projectionDifferenceDays ==
              null
              ? null
              : stats.projectionDifferenceDays! <=
              -3
              ? true
              : stats.projectionDifferenceDays! >=
              3
              ? false
              : null,
          goalWeight:
          stats.targetWeight,
          weightUnit:
          stats.weightUnit,
        ),

        const SizedBox(height: 24),

        PlanWeightProgressChart(
          planActivatedAt:
          stats.planActivatedAt,
          expectedGoalDate:
          stats.expectedGoalDate,
          planStartWeight:
          stats.planStartWeight,
          targetWeight:
          stats.targetWeight,
          weightPoints:
          stats.weightPoints,
          weightUnit:
          stats.weightUnit,
        ),

        const SizedBox(height: 30),

        if (isAiNoteLoading)
          const PlanStatusNoteShimmer()
        else
          PlanStatusNoteCard(
            status:
            stats.planStatus,
            aiNote:
            stats.aiNote,
            estimatedGoalDate:
            stats.estimatedGoalDate == null
                ? '-'
                : '${stats.estimatedGoalDate!.day} '
                '${_formatShortMonth(
              context,
              stats.estimatedGoalDate!,
            )} '
                '${stats.estimatedGoalDate!.year}',
            onReviewPlan:
            onReviewPlan,
          ),
      ],
    );
  }
}