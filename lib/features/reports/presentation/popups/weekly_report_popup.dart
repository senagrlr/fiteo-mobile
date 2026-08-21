import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';

import 'package:fiteo_myapp/features/reports/models/weekly_report_data.dart';

import 'package:fiteo_myapp/features/reports/presentation/widgets/report_header.dart';
import 'package:fiteo_myapp/features/reports/presentation/widgets/report_score_section.dart';

import 'package:fiteo_myapp/features/reports/presentation/widgets/weekly/weekly_best_worst_day.dart';
import 'package:fiteo_myapp/features/reports/presentation/widgets/weekly/weekly_day_detail_card.dart';
import 'package:fiteo_myapp/features/reports/presentation/widgets/weekly/weekly_metrics_card.dart';
import 'package:fiteo_myapp/features/reports/presentation/widgets/weekly/weekly_next_week_card.dart';
import 'package:fiteo_myapp/features/reports/presentation/widgets/weekly/weekly_overview_card.dart';
import 'package:fiteo_myapp/features/reports/presentation/widgets/weekly/weekly_review_card.dart';
import 'package:fiteo_myapp/features/reports/presentation/widgets/weekly/weekly_weight_plan_card.dart';

class WeeklyReportPopup extends StatefulWidget {
  final WeeklyReportData data;

  const WeeklyReportPopup({
    super.key,
    required this.data,
  });

  @override
  State<WeeklyReportPopup> createState() =>
      _WeeklyReportPopupState();
}

class _WeeklyReportPopupState
    extends State<WeeklyReportPopup> {
  bool showBestDay = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.of(context).size.width;

    final selectedDay = showBestDay
        ? widget.data.bestDay
        : widget.data.worstDay;

    return FractionallySizedBox(
      heightFactor: 0.96,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.surfacePrimary,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(34),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            physics:
            const ClampingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              screenWidth * 0.07,
              16,
              screenWidth * 0.07,
              48,
            ),
            child: Column(
              children: [
                ReportHeader(
                  title:
                  context.l10n.weeklyReport,
                  dateRange:
                  widget.data.dateRange,
                  onClose: () {
                    Navigator.pop(context);
                  },
                ),

                const SizedBox(height: 16),

                ReportScoreSection(
                  score: widget.data.score,
                  change:
                  widget.data.scoreChange,
                  scoreLabel:
                  widget.data.scoreLabel,
                  changeLabel:
                  context.l10n
                      .weeklyScoreChange(
                    widget.data.scoreChange
                        .abs(),
                  ),
                ),

                const SizedBox(height: 28),

                WeeklyOverviewCard(
                  data:
                  widget.data.overview,
                ),

                const SizedBox(height: 22),

                WeeklyMetricsCard(
                  data:
                  widget.data.metrics,
                ),

                const SizedBox(height: 26),

                WeeklyBestWorstDay(
                  showBestDay:
                  showBestDay,
                  onChanged: (value) {
                    setState(() {
                      showBestDay = value;
                    });
                  },
                ),

                const SizedBox(height: 12),

                AnimatedSwitcher(
                  duration: const Duration(
                    milliseconds: 220,
                  ),
                  child:
                  WeeklyDayDetailCard(
                    key: ValueKey(
                      showBestDay,
                    ),
                    data: selectedDay,
                  ),
                ),

                const SizedBox(height: 34),

                WeeklyWeightPlanCard(
                  data:
                  widget.data.weightPlan,
                ),

                const SizedBox(height: 34),

                WeeklyReviewCard(
                  paragraphs:
                  widget.data
                      .reviewParagraphs,
                ),

                const SizedBox(height: 36),

                WeeklyNextWeekCard(
                  data:
                  widget.data.nextWeek,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// POPUP AÇMA
// ============================================================

Future<void> showWeeklyReportPopup(
    BuildContext context,
    WeeklyReportData data,
    ) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor:
    Colors.black.withValues(
      alpha: 0.30,
    ),
    builder: (_) {
      return WeeklyReportPopup(
        data: data,
      );
    },
  );
}