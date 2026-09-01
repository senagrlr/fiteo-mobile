import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';

import 'package:fiteo_myapp/features/reports/models/monthly_report_data.dart';

import 'package:fiteo_myapp/features/reports/presentation/widgets/report_header.dart';
import 'package:fiteo_myapp/features/reports/presentation/widgets/report_score_section.dart';

import 'package:fiteo_myapp/features/reports/presentation/widgets/monthly/monthly_consistency_card.dart';
import 'package:fiteo_myapp/features/reports/presentation/widgets/monthly/monthly_metrics_card.dart';
import 'package:fiteo_myapp/features/reports/presentation/widgets/monthly/monthly_overview_card.dart';
import 'package:fiteo_myapp/features/reports/presentation/widgets/monthly/monthly_next_month_card.dart';
import 'package:fiteo_myapp/features/reports/presentation/widgets/monthly/monthly_review_card.dart';
import 'package:fiteo_myapp/features/reports/presentation/widgets/monthly/monthly_strongest_weakest_area.dart';
import 'package:fiteo_myapp/features/reports/presentation/widgets/monthly/monthly_weight_plan_card.dart';

class MonthlyReportPopup extends StatelessWidget {
  final MonthlyReportData data;

  const MonthlyReportPopup({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.of(context).size.width;

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
                  context.l10n.monthlyReport,
                  dateRange:
                  data.dateRange,
                  onClose: () {
                    Navigator.pop(context);
                  },
                ),

                const SizedBox(height: 16),

                ReportScoreSection(
                  score:
                  data.score,
                  change:
                  data.scoreChange,
                  scoreLabel:
                  data.scoreLabel,
                  changeLabel:
                  context.l10n.monthlyScoreChange(
                    data.scoreChange.abs(),
                  ),
                ),

                const SizedBox(height: 28),

                MonthlyOverviewCard(
                  data:
                  data.overview,
                ),

                const SizedBox(height: 22),

                MonthlyMetricsCard(
                  data:
                  data.metrics,
                ),

                const SizedBox(height: 26),

                MonthlyStrongestWeakestArea(
                  strongestArea: data.strongestArea,
                  weakestArea: data.weakestArea,
                ),

                const SizedBox(height: 28),

                MonthlyConsistencyCard(
                  data:
                  data.consistency,
                ),

                const SizedBox(height: 28),

                MonthlyWeightPlanCard(
                  data:
                  data.weightPlan,
                ),

                const SizedBox(height: 30),

                MonthlyReviewCard(
                  paragraphs: data.reviewParagraphs,
                ),

                const SizedBox(height: 30),

                MonthlyNextMonthCard(
                  data: data.nextMonth,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> showMonthlyReportPopup(
    BuildContext context,
    MonthlyReportData data,
    ) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(
      alpha: 0.30,
    ),
    builder: (_) {
      return MonthlyReportPopup(
        data: data,
      );
    },
  );
}