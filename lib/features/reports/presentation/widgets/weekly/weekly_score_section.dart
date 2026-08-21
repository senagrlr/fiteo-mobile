import 'package:flutter/material.dart';

import 'package:fiteo_myapp/features/reports/presentation/widgets/report_score_section.dart';

class WeeklyScoreSection extends StatelessWidget {
  final int score;
  final int change;
  final String scoreLabel;
  final String changeLabel;

  const WeeklyScoreSection({
    super.key,
    required this.score,
    required this.change,
    required this.scoreLabel,
    required this.changeLabel,
  });

  @override
  Widget build(BuildContext context) {
    return ReportScoreSection(
      score: score,
      change: change,
      scoreLabel: scoreLabel,
      changeLabel: changeLabel,
    );
  }
}