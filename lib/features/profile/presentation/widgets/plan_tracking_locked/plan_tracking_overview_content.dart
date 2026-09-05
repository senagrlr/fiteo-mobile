import 'package:flutter/material.dart';

import 'package:fiteo_myapp/features/profile/presentation/models/overview_achievement.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/overview_stats.dart';

import 'package:fiteo_myapp/features/profile/presentation/widgets/fiteo_overview_note_card.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/fiteo_overview_note_shimmer.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/tracking_summary_card.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/unique_features_card.dart';

class PlanTrackingOverviewContent
    extends StatelessWidget {
  final OverviewStats stats;
  final List<OverviewAchievement> achievements;
  final bool isAiNoteLoading;

  const PlanTrackingOverviewContent({
    super.key,
    required this.stats,
    required this.achievements,
    this.isAiNoteLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TrackingSummaryCard(
          trackingConsistency:
          stats.trackingConsistency.round(),
          goalAchievement:
          stats.goalAchievement.round(),
        ),

        const SizedBox(height: 24),

        UniqueFeaturesCard(
          achievements: achievements,
        ),

        const SizedBox(height: 30),

        if (isAiNoteLoading)
          const FiteoOverviewNoteShimmer()
        else
          FiteoOverviewNoteCard(
            note: stats.aiNote,
          ),
      ],
    );
  }
}