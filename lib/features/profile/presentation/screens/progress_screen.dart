import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/common/widgets/system_navigation_bar.dart';

import 'package:fiteo_myapp/features/profile/presentation/models/progress_models.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/progress_chart_card.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/progress_metric_tabs.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/progress_summary_card.dart';
import 'package:fiteo_myapp/features/profile/data/progress_repository.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/progress_data_builder.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/progress_snapshot.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/progress_nutrition_tabs.dart';
import 'package:fiteo_myapp/features/membership/data/premium_access_service.dart';
import 'package:fiteo_myapp/features/membership/domain/premium_feature.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/progress_locked_content.dart';

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
  ProgressMetric selectedMetric = ProgressMetric.weight;

  final Map<ProgressMetric, ProgressRange> _selectedRanges = {
    ProgressMetric.weight: ProgressRange.days30,
    ProgressMetric.nutrition: ProgressRange.days7,
    ProgressMetric.water: ProgressRange.days7,
    ProgressMetric.workout: ProgressRange.days7,
  };

  ProgressRange get selectedRange => _selectedRanges[selectedMetric]!;

  final ProgressRepository _progressRepository =
  ProgressRepository();

  final PremiumAccessService _premiumAccessService =
  PremiumAccessService();

  ProgressSnapshot? _snapshot;

  bool _isLoading = true;
  bool _hasError = false;
  bool _isPremium = false;
  bool _showLockedContent = false;
  String _lockedContentTitle = '';

  ProgressNutritionMetric selectedNutritionMetric =
      ProgressNutritionMetric.calories;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    try {
      final isPremium =
      await _premiumAccessService.canAccess(
        PremiumFeature.extendedProgress,
      );

      final snapshot =
      await _progressRepository.loadProgress(
        isPremium: isPremium,
      );

      if (!mounted) return;

      setState(() {
        _isPremium = isPremium;
        _snapshot = snapshot;

        if (!isPremium) {
          selectedMetric = ProgressMetric.nutrition;

          _selectedRanges[
          ProgressMetric.nutrition
          ] = ProgressRange.days7;

          _selectedRanges[
          ProgressMetric.water
          ] = ProgressRange.days7;

          _selectedRanges[
          ProgressMetric.workout
          ] = ProgressRange.days7;
        }

        _isLoading = false;
        _hasError = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _onMetricChanged(
      ProgressMetric metric,
      ) {
    if (!_isPremium &&
        metric == ProgressMetric.weight) {
      setState(() {
        _showLockedContent = true;
        _lockedContentTitle = 'Weight Progress';
      });
      return;
    }

    setState(() {
      selectedMetric = metric;
      _showLockedContent = false;
      _lockedContentTitle = '';
    });
  }

  void _onRangeChanged(
      ProgressRange range,
      ) {
    if (!_isPremium &&
        range != ProgressRange.days7) {
      setState(() {
        _showLockedContent = true;
        _lockedContentTitle = _lockedRangeTitle(range);
      });
      return;
    }

    setState(() {
      _selectedRanges[selectedMetric] = range;
      _showLockedContent = false;
      _lockedContentTitle = '';
    });
  }

  void _onNutritionMetricChanged(
      ProgressNutritionMetric metric,
      ) {
    setState(() {
      selectedNutritionMetric = metric;
    });
  }

  String _lockedRangeTitle(
      ProgressRange range,
      ) {
    switch (range) {
      case ProgressRange.days7:
        return '7 Day Progress';

      case ProgressRange.days30:
        return '30 Day Progress';

      case ProgressRange.days90:
        return '90 Day Progress';

      case ProgressRange.days365:
        return '365 Day Progress';
    }
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
          child: _isLoading
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : _hasError || _snapshot == null
              ? Center(
            child: IconButton(
              onPressed: _loadProgress,
              icon: const Icon(
                Icons.refresh_rounded,
                color: AppColors.homeBrown,
              ),
            ),
          )
              : _buildContent(
            context,
            screenWidth,
            _snapshot!,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context,
      double screenWidth,
      ProgressSnapshot snapshot,
      ) {
    final builder = ProgressDataBuilder(
      context: context,
      snapshot: snapshot,
    );

    final chartData = builder.buildChart(
      metric: selectedMetric,
      range: selectedRange,
      nutritionMetric: selectedNutritionMetric,
    );

    final summary = builder.buildSummary(
      metric: selectedMetric,
      range: selectedRange,
      nutritionMetric: selectedNutritionMetric,
    );

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        screenWidth * 0.07,
        18,
        screenWidth * 0.07,
        45,
      ),
      child: Column(
        children: [
          ProgressMetricTabs(
            selectedMetric: selectedMetric,
            onChanged: _onMetricChanged,
            isPremium: _isPremium,
          ),

          if (selectedMetric == ProgressMetric.nutrition) ...[
            const SizedBox(height: 14),

            ProgressNutritionTabs(
              selectedMetric: selectedNutritionMetric,
              onChanged: _onNutritionMetricChanged,
            ),
          ],

          const SizedBox(height: 24),

          if (_showLockedContent)
            ProgressLockedContent(
              title: _lockedContentTitle,
            )
          else ...[
            ProgressChartCard(
              data: chartData,
              selectedRange: selectedRange,
              availableRanges: _availableRanges,
              onRangeChanged: _onRangeChanged,
              isPremium: _isPremium,
            ),

            const SizedBox(height: 26),

            ProgressSummaryCard(
              data: _buildRealSummaryData(
                context,
                builder,
                summary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  ProgressSummaryData _buildRealSummaryData(
      BuildContext context,
      ProgressDataBuilder builder,
      ProgressSummaryValues values,
      ) {
    switch (selectedMetric) {
      case ProgressMetric.nutrition:
        return ProgressSummaryData(
          dateRange: builder.dateRangeLabel(selectedRange),
          primaryItem: ProgressSummaryItem(
            value: values.primary,
            label: _nutritionAverageLabel(context),
          ),
          bottomLeftItem: ProgressSummaryItem(
            value: values.left,
            label: context.l10n.target,
          ),
          bottomRightItem: ProgressSummaryItem(
            value: values.right,
            label: context.l10n.onTargetDays,
          ),
        );

      case ProgressMetric.water:
        return ProgressSummaryData(
          dateRange: builder.dateRangeLabel(selectedRange),
          primaryItem: ProgressSummaryItem(
            value: values.primary,
            label: context.l10n.dailyAverageWater,
          ),
          bottomLeftItem: ProgressSummaryItem(
            value: values.left,
            label: context.l10n.target,
          ),
          bottomRightItem: ProgressSummaryItem(
            value: values.right,
            label: context.l10n.onTargetDays,
          ),
        );

      case ProgressMetric.workout:
        return ProgressSummaryData(
          dateRange: builder.dateRangeLabel(selectedRange),
          primaryItem: ProgressSummaryItem(
            value: values.primary,
            label: context.l10n.totalWorkout,
          ),
          bottomLeftItem: ProgressSummaryItem(
            value: values.left,
            label: context.l10n.activeDays,
          ),
          bottomRightItem: ProgressSummaryItem(
            value: values.right,
            label: context.l10n.averageDuration,
          ),
        );

      case ProgressMetric.weight:
        return ProgressSummaryData(
          dateRange: builder.dateRangeLabel(selectedRange),
          primaryItem: ProgressSummaryItem(
            value: values.primary,
            label: 'Total Change',
          ),
          bottomLeftItem: ProgressSummaryItem(
            value: values.left,
            label: 'Weekly Rate',
          ),
          bottomRightItem: ProgressSummaryItem(
            value: values.right,
            label: 'Remaining',
          ),
        );
    }
  }

  String _nutritionAverageLabel(BuildContext context) {
    switch (selectedNutritionMetric) {
      case ProgressNutritionMetric.calories:
        return context.l10n.dailyAverageCalories;

      case ProgressNutritionMetric.protein:
        return 'Daily Average Protein';

      case ProgressNutritionMetric.carbs:
        return 'Daily Average Carbs';

      case ProgressNutritionMetric.fat:
        return 'Daily Average Fat';
    }
  }
}