import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/common/widgets/system_navigation_bar.dart';

import 'package:fiteo_myapp/features/profile/presentation/models/progress_models.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/progress_chart_card.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/progress_metric_tabs.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/progress_summary_card.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({
    super.key,
  });

  @override
  State<ProgressScreen> createState() =>
      _ProgressScreenState();
}

class _ProgressScreenState
    extends State<ProgressScreen> {
  ProgressMetric selectedMetric =
      ProgressMetric.weight;

  ProgressRange selectedRange =
      ProgressRange.days30;

  void _onMetricChanged(
      ProgressMetric metric,
      ) {
    setState(() {
      selectedMetric = metric;

      // Weight için 7 günlük görünüm yok.
      if (metric == ProgressMetric.weight &&
          selectedRange == ProgressRange.days7) {
        selectedRange = ProgressRange.days30;
      }
    });
  }

  void _onRangeChanged(
      ProgressRange range,
      ) {
    setState(() {
      selectedRange = range;
    });
  }

  List<ProgressRange> get _availableRanges {
    if (selectedMetric == ProgressMetric.weight) {
      return const [
        ProgressRange.days30,
        ProgressRange.days90,
        ProgressRange.days365,
      ];
    }

    return const [
      ProgressRange.days7,
      ProgressRange.days30,
      ProgressRange.days90,
      ProgressRange.days365,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.of(context).size.width;

    return SystemNavigationBar(
      color: AppColors.surfacePrimary,
      child: Scaffold(
        backgroundColor:
        AppColors.surfacePrimary,
        appBar: AppBar(
          backgroundColor:
          AppColors.surfacePrimary,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.homeBrown,
              size: 20,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            context.l10n.progress,
            style:
            AppTextStyles.titleMedium.copyWith(
              color: AppColors.homeBrown,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics:
            const ClampingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              screenWidth * 0.07,
              18,
              screenWidth * 0.07,
              45,
            ),
            child: Column(
              children: [
                ProgressMetricTabs(
                  selectedMetric:
                  selectedMetric,
                  onChanged:
                  _onMetricChanged,
                ),

                const SizedBox(height: 24),

                ProgressChartCard(
                  data: _buildChartData(),
                  selectedRange:
                  selectedRange,
                  availableRanges:
                  _availableRanges,
                  onRangeChanged:
                  _onRangeChanged,
                ),

                const SizedBox(height: 26),

                ProgressSummaryCard(
                  data: _buildSummaryData(
                    context,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ProgressChartData _buildChartData() {
    switch (selectedMetric) {
      case ProgressMetric.nutrition:
        return _nutritionData();

      case ProgressMetric.water:
        return _waterData();

      case ProgressMetric.workout:
        return _workoutData();

      case ProgressMetric.weight:
        return _weightData();
    }
  }

  // ============================================================
  // NUTRITION
  // ============================================================

  ProgressChartData _nutritionData() {
    const color =
        AppColors.planTrackingProteinBadge;

    switch (selectedRange) {
      case ProgressRange.days7:
        return const ProgressChartData(
          lineColor: color,
          spots: [
            FlSpot(0, 420),
            FlSpot(1, 510),
            FlSpot(2, 470),
            FlSpot(3, 560),
            FlSpot(4, 495),
            FlSpot(5, 590),
            FlSpot(6, 525),
          ],
          bottomLabels: [
            'Pzt',
            'Sal',
            'Çar',
            'Per',
            'Cum',
            'Cmt',
            'Paz',
          ],
          minY: 300,
          maxY: 700,
          interval: 100,
          targetY: 550,
          tooltipUnit: 'kcal',
        );

      case ProgressRange.days30:
        return const ProgressChartData(
          lineColor: color,
          spots: [
            FlSpot(0, 470),
            FlSpot(1, 515),
            FlSpot(2, 490),
            FlSpot(3, 540),
            FlSpot(4, 510),
          ],
          bottomLabels: [
            'H1',
            'H2',
            'H3',
            'H4',
            'H5',
          ],
          minY: 300,
          maxY: 700,
          interval: 100,
          targetY: 550,
          tooltipUnit: 'kcal',
        );

      case ProgressRange.days90:
        return const ProgressChartData(
          lineColor: color,
          spots: [
            FlSpot(0, 430),
            FlSpot(1, 460),
            FlSpot(2, 480),
            FlSpot(3, 500),
            FlSpot(4, 470),
            FlSpot(5, 520),
            FlSpot(6, 500),
            FlSpot(7, 540),
            FlSpot(8, 510),
            FlSpot(9, 530),
            FlSpot(10, 520),
            FlSpot(11, 550),
            FlSpot(12, 535),
          ],
          bottomLabels: [
            'H1',
            '',
            'H3',
            '',
            'H5',
            '',
            'H7',
            '',
            'H9',
            '',
            'H11',
            '',
            'H13',
          ],
          minY: 300,
          maxY: 700,
          interval: 100,
          targetY: 550,
          tooltipUnit: 'kcal',
        );

      case ProgressRange.days365:
        return const ProgressChartData(
          lineColor: color,
          spots: [
            FlSpot(0, 450),
            FlSpot(1, 470),
            FlSpot(2, 490),
            FlSpot(3, 480),
            FlSpot(4, 510),
            FlSpot(5, 520),
            FlSpot(6, 500),
            FlSpot(7, 540),
            FlSpot(8, 525),
            FlSpot(9, 535),
            FlSpot(10, 520),
            FlSpot(11, 545),
          ],
          bottomLabels: [
            'O',
            'Ş',
            'M',
            'N',
            'M',
            'H',
            'T',
            'A',
            'E',
            'E',
            'K',
            'A',
          ],
          minY: 300,
          maxY: 700,
          interval: 100,
          targetY: 550,
          tooltipUnit: 'kcal',
        );
    }
  }

  // ============================================================
  // WATER
  // ============================================================

  ProgressChartData _waterData() {
    const color =
        AppColors.planTrackingActiveDayBadge;

    switch (selectedRange) {
      case ProgressRange.days7:
        return const ProgressChartData(
          lineColor: color,
          spots: [
            FlSpot(0, 1.8),
            FlSpot(1, 2.3),
            FlSpot(2, 2.1),
            FlSpot(3, 2.5),
            FlSpot(4, 2.0),
            FlSpot(5, 2.6),
            FlSpot(6, 2.4),
          ],
          bottomLabels: [
            'Pzt',
            'Sal',
            'Çar',
            'Per',
            'Cum',
            'Cmt',
            'Paz',
          ],
          minY: 1,
          maxY: 3,
          interval: 0.5,
          targetY: 2.5,
          tooltipUnit: 'L',
        );

      case ProgressRange.days30:
        return const ProgressChartData(
          lineColor: color,
          spots: [
            FlSpot(0, 2.0),
            FlSpot(1, 2.2),
            FlSpot(2, 2.1),
            FlSpot(3, 2.4),
            FlSpot(4, 2.3),
          ],
          bottomLabels: [
            'H1',
            'H2',
            'H3',
            'H4',
            'H5',
          ],
          minY: 1,
          maxY: 3,
          interval: 0.5,
          targetY: 2.5,
          tooltipUnit: 'L',
        );

      case ProgressRange.days90:
        return const ProgressChartData(
          lineColor: color,
          spots: [
            FlSpot(0, 1.9),
            FlSpot(1, 2.0),
            FlSpot(2, 2.1),
            FlSpot(3, 2.2),
            FlSpot(4, 2.1),
            FlSpot(5, 2.3),
            FlSpot(6, 2.2),
            FlSpot(7, 2.4),
            FlSpot(8, 2.3),
            FlSpot(9, 2.2),
            FlSpot(10, 2.4),
            FlSpot(11, 2.5),
            FlSpot(12, 2.4),
          ],
          bottomLabels: [
            'H1',
            '',
            'H3',
            '',
            'H5',
            '',
            'H7',
            '',
            'H9',
            '',
            'H11',
            '',
            'H13',
          ],
          minY: 1,
          maxY: 3,
          interval: 0.5,
          targetY: 2.5,
          tooltipUnit: 'L',
        );

      case ProgressRange.days365:
        return const ProgressChartData(
          lineColor: color,
          spots: [
            FlSpot(0, 1.9),
            FlSpot(1, 2.0),
            FlSpot(2, 2.1),
            FlSpot(3, 2.0),
            FlSpot(4, 2.2),
            FlSpot(5, 2.3),
            FlSpot(6, 2.2),
            FlSpot(7, 2.4),
            FlSpot(8, 2.3),
            FlSpot(9, 2.4),
            FlSpot(10, 2.3),
            FlSpot(11, 2.5),
          ],
          bottomLabels: [
            'O',
            'Ş',
            'M',
            'N',
            'M',
            'H',
            'T',
            'A',
            'E',
            'E',
            'K',
            'A',
          ],
          minY: 1,
          maxY: 3,
          interval: 0.5,
          targetY: 2.5,
          tooltipUnit: 'L',
        );
    }
  }

  // ============================================================
  // WORKOUT
  // ============================================================

  ProgressChartData _workoutData() {
    const color =
        AppColors.planTrackingStreakBadge;

    switch (selectedRange) {
      case ProgressRange.days7:
        return const ProgressChartData(
          lineColor: color,
          spots: [
            FlSpot(0, 30),
            FlSpot(1, 45),
            FlSpot(2, 20),
            FlSpot(3, 50),
            FlSpot(4, 35),
            FlSpot(5, 55),
            FlSpot(6, 40),
          ],
          bottomLabels: [
            'Pzt',
            'Sal',
            'Çar',
            'Per',
            'Cum',
            'Cmt',
            'Paz',
          ],
          minY: 0,
          maxY: 60,
          interval: 15,
          targetY: 40,
          tooltipUnit: 'dk',
        );

      case ProgressRange.days30:
        return const ProgressChartData(
          lineColor: color,
          spots: [
            FlSpot(0, 35),
            FlSpot(1, 42),
            FlSpot(2, 39),
            FlSpot(3, 47),
            FlSpot(4, 44),
          ],
          bottomLabels: [
            'H1',
            'H2',
            'H3',
            'H4',
            'H5',
          ],
          minY: 0,
          maxY: 60,
          interval: 15,
          targetY: 40,
          tooltipUnit: 'dk',
        );

      case ProgressRange.days90:
        return const ProgressChartData(
          lineColor: color,
          spots: [
            FlSpot(0, 30),
            FlSpot(1, 35),
            FlSpot(2, 40),
            FlSpot(3, 38),
            FlSpot(4, 43),
            FlSpot(5, 45),
            FlSpot(6, 42),
            FlSpot(7, 48),
            FlSpot(8, 44),
            FlSpot(9, 46),
            FlSpot(10, 43),
            FlSpot(11, 49),
            FlSpot(12, 46),
          ],
          bottomLabels: [
            'H1',
            '',
            'H3',
            '',
            'H5',
            '',
            'H7',
            '',
            'H9',
            '',
            'H11',
            '',
            'H13',
          ],
          minY: 0,
          maxY: 60,
          interval: 15,
          targetY: 40,
          tooltipUnit: 'dk',
        );

      case ProgressRange.days365:
        return const ProgressChartData(
          lineColor: color,
          spots: [
            FlSpot(0, 34),
            FlSpot(1, 36),
            FlSpot(2, 39),
            FlSpot(3, 38),
            FlSpot(4, 42),
            FlSpot(5, 44),
            FlSpot(6, 46),
            FlSpot(7, 43),
            FlSpot(8, 47),
            FlSpot(9, 45),
            FlSpot(10, 46),
            FlSpot(11, 48),
          ],
          bottomLabels: [
            'O',
            'Ş',
            'M',
            'N',
            'M',
            'H',
            'T',
            'A',
            'E',
            'E',
            'K',
            'A',
          ],
          minY: 0,
          maxY: 60,
          interval: 15,
          targetY: 40,
          tooltipUnit: 'dk',
        );
    }
  }

  // ============================================================
  // WEIGHT
  // ============================================================

  ProgressChartData _weightData() {
    const color =
        AppColors.homeBrown;

    switch (selectedRange) {
    // Normalde buraya ulaşılamaz.
    // Güvenli fallback olarak 30 gün veriyoruz.
      case ProgressRange.days7:
      case ProgressRange.days30:
        return const ProgressChartData(
          lineColor: color,
          spots: [
            FlSpot(0, 80),
            FlSpot(1, 79.5),
            FlSpot(2, 79),
            FlSpot(3, 78.4),
            FlSpot(4, 77.8),
          ],
          bottomLabels: [
            'H1',
            'H2',
            'H3',
            'H4',
            'H5',
          ],
          minY: 75,
          maxY: 81,
          interval: 1,
          targetY: 77,
          tooltipUnit: 'kg',
        );

      case ProgressRange.days90:
        return const ProgressChartData(
          lineColor: color,
          spots: [
            FlSpot(0, 81),
            FlSpot(1, 80.7),
            FlSpot(2, 80.4),
            FlSpot(3, 80),
            FlSpot(4, 79.8),
            FlSpot(5, 79.5),
            FlSpot(6, 79.1),
            FlSpot(7, 78.9),
            FlSpot(8, 78.6),
            FlSpot(9, 78.4),
            FlSpot(10, 78.1),
            FlSpot(11, 77.9),
            FlSpot(12, 77.5),
          ],
          bottomLabels: [
            'H1',
            '',
            'H3',
            '',
            'H5',
            '',
            'H7',
            '',
            'H9',
            '',
            'H11',
            '',
            'H13',
          ],
          minY: 75,
          maxY: 82,
          interval: 1,
          targetY: 77,
          tooltipUnit: 'kg',
        );

      case ProgressRange.days365:
        return const ProgressChartData(
          lineColor: color,
          spots: [
            FlSpot(0, 84),
            FlSpot(1, 83.5),
            FlSpot(2, 83),
            FlSpot(3, 82.4),
            FlSpot(4, 81.8),
            FlSpot(5, 81),
            FlSpot(6, 80.4),
            FlSpot(7, 79.7),
            FlSpot(8, 79),
            FlSpot(9, 78.5),
            FlSpot(10, 78),
            FlSpot(11, 77),
          ],
          bottomLabels: [
            'O',
            'Ş',
            'M',
            'N',
            'M',
            'H',
            'T',
            'A',
            'E',
            'E',
            'K',
            'A',
          ],
          minY: 75,
          maxY: 85,
          interval: 2,
          targetY: 77,
          tooltipUnit: 'kg',
        );
    }
  }

  // ============================================================
  // SUMMARY
  // ============================================================

  ProgressSummaryData _buildSummaryData(
      BuildContext context,
      ) {
    switch (selectedMetric) {
      case ProgressMetric.nutrition:
        return ProgressSummaryData(
          dateRange:
          _dateRangeLabel(selectedRange),
          primaryItem: ProgressSummaryItem(
            value: _nutritionAverage(),
            label:
            context.l10n.dailyAverageCalories,
          ),
          bottomLeftItem:
          ProgressSummaryItem(
            value: '550',
            label: context.l10n.target,
          ),
          bottomRightItem:
          ProgressSummaryItem(
            value: _nutritionTargetDays(),
            label: context.l10n.onTargetDays,
          ),
        );

      case ProgressMetric.water:
        return ProgressSummaryData(
          dateRange:
          _dateRangeLabel(selectedRange),
          primaryItem: ProgressSummaryItem(
            value: _waterAverage(),
            label:
            context.l10n.dailyAverageWater,
          ),
          bottomLeftItem:
          ProgressSummaryItem(
            value: '2.5 L',
            label: context.l10n.target,
          ),
          bottomRightItem:
          ProgressSummaryItem(
            value: _waterTargetDays(),
            label: context.l10n.onTargetDays,
          ),
        );

      case ProgressMetric.workout:
        return ProgressSummaryData(
          dateRange:
          _dateRangeLabel(selectedRange),
          primaryItem: ProgressSummaryItem(
            value: _totalWorkout(),
            label: context.l10n.totalWorkout,
          ),
          bottomLeftItem:
          ProgressSummaryItem(
            value: _activeDays(),
            label: context.l10n.activeDays,
          ),
          bottomRightItem:
          ProgressSummaryItem(
            value: _averageDuration(),
            label:
            context.l10n.averageDuration,
          ),
        );

      case ProgressMetric.weight:
        return ProgressSummaryData(
          dateRange:
          _dateRangeLabel(selectedRange),
          primaryItem:
          ProgressSummaryItem(
            value: _totalWeightChange(),
            label: context.l10n.totalChange,
          ),
          bottomLeftItem:
          ProgressSummaryItem(
            value: _weeklyRate(),
            label: context.l10n.weeklyRate,
          ),
          bottomRightItem:
          ProgressSummaryItem(
            value: '3.0 kg',
            label: context.l10n.remaining,
          ),
        );
    }
  }

  String _dateRangeLabel(
      ProgressRange range,
      ) {
    switch (range) {
      case ProgressRange.days7:
        return '09.05.2026 - 15.05.2026';

      case ProgressRange.days30:
        return '16.04.2026 - 15.05.2026';

      case ProgressRange.days90:
        return '15.02.2026 - 15.05.2026';

      case ProgressRange.days365:
        return '16.05.2025 - 15.05.2026';
    }
  }

  String _nutritionAverage() {
    switch (selectedRange) {
      case ProgressRange.days7:
        return '510';

      case ProgressRange.days30:
        return '505';

      case ProgressRange.days90:
        return '503';

      case ProgressRange.days365:
        return '507';
    }
  }

  String _nutritionTargetDays() {
    switch (selectedRange) {
      case ProgressRange.days7:
        return '5/7';

      case ProgressRange.days30:
        return '22/30';

      case ProgressRange.days90:
        return '64/90';

      case ProgressRange.days365:
        return '281/365';
    }
  }

  String _waterAverage() {
    switch (selectedRange) {
      case ProgressRange.days7:
        return '2.2 L';

      case ProgressRange.days30:
        return '2.1 L';

      case ProgressRange.days90:
        return '2.2 L';

      case ProgressRange.days365:
        return '2.3 L';
    }
  }

  String _waterTargetDays() {
    switch (selectedRange) {
      case ProgressRange.days7:
        return '4/7';

      case ProgressRange.days30:
        return '18/30';

      case ProgressRange.days90:
        return '57/90';

      case ProgressRange.days365:
        return '244/365';
    }
  }

  String _totalWorkout() {
    switch (selectedRange) {
      case ProgressRange.days7:
        return '4';

      case ProgressRange.days30:
        return '14';

      case ProgressRange.days90:
        return '38';

      case ProgressRange.days365:
        return '146';
    }
  }

  String _activeDays() {
    switch (selectedRange) {
      case ProgressRange.days7:
        return '4';

      case ProgressRange.days30:
        return '11';

      case ProgressRange.days90:
        return '31';

      case ProgressRange.days365:
        return '118';
    }
  }

  String _averageDuration() {
    switch (selectedRange) {
      case ProgressRange.days7:
        return '40 dk';

      case ProgressRange.days30:
        return '42 dk';

      case ProgressRange.days90:
        return '44 dk';

      case ProgressRange.days365:
        return '46 dk';
    }
  }

  String _totalWeightChange() {
    switch (selectedRange) {
      case ProgressRange.days7:
      case ProgressRange.days30:
        return '-2.4 kg';

      case ProgressRange.days90:
        return '-5.1 kg';

      case ProgressRange.days365:
        return '-7.0 kg';
    }
  }

  String _weeklyRate() {
    switch (selectedRange) {
      case ProgressRange.days7:
      case ProgressRange.days30:
        return '-0.6 kg';

      case ProgressRange.days90:
        return '-0.4 kg';

      case ProgressRange.days365:
        return '-0.13 kg';
    }
  }
}