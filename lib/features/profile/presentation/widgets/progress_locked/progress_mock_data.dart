import 'package:fl_chart/fl_chart.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/progress_models.dart';

class ProgressMockData {
  ProgressMockData._();

  static ProgressChartData chart({
    required ProgressMetric metric,
    required ProgressRange range,
    required ProgressNutritionMetric nutritionMetric,
  }) {
    switch (metric) {
      case ProgressMetric.nutrition:
        return _nutritionChart(
          range: range,
          nutritionMetric: nutritionMetric,
        );

      case ProgressMetric.water:
        return _waterChart(range);

      case ProgressMetric.workout:
        return _workoutChart(range);

      case ProgressMetric.weight:
        return _weightChart(range);
    }
  }

  static ProgressSummaryData summary({
    required ProgressMetric metric,
    required ProgressRange range,
    required ProgressNutritionMetric nutritionMetric,
  }) {
    switch (metric) {
      case ProgressMetric.nutrition:
        return ProgressSummaryData(
          dateRange: _rangeLabel(range),
          primaryItem: ProgressSummaryItem(
            value: _nutritionAverage(
              nutritionMetric,
            ),
            label: _nutritionAverageLabel(
              nutritionMetric,
            ),
          ),
          bottomLeftItem: ProgressSummaryItem(
            value: _nutritionTarget(
              nutritionMetric,
            ),
            label: 'Target',
          ),
          bottomRightItem: ProgressSummaryItem(
            value: _targetDays(range),
            label: 'On Target Days',
          ),
        );

      case ProgressMetric.water:
        return ProgressSummaryData(
          dateRange: _rangeLabel(range),
          primaryItem: const ProgressSummaryItem(
            value: '2.3 L',
            label: 'Daily Average Water',
          ),
          bottomLeftItem: const ProgressSummaryItem(
            value: '2.5 L',
            label: 'Target',
          ),
          bottomRightItem: ProgressSummaryItem(
            value: _targetDays(range),
            label: 'On Target Days',
          ),
        );

      case ProgressMetric.workout:
        return ProgressSummaryData(
          dateRange: _rangeLabel(range),
          primaryItem: const ProgressSummaryItem(
            value: '18',
            label: 'Total Workout',
          ),
          bottomLeftItem: const ProgressSummaryItem(
            value: '14',
            label: 'Active Days',
          ),
          bottomRightItem: const ProgressSummaryItem(
            value: '42 min',
            label: 'Average Duration',
          ),
        );

      case ProgressMetric.weight:
        return ProgressSummaryData(
          dateRange: _rangeLabel(range),
          primaryItem: const ProgressSummaryItem(
            value: '-3.2 kg',
            label: 'Total Change',
          ),
          bottomLeftItem: const ProgressSummaryItem(
            value: '-0.5 kg',
            label: 'Weekly Rate',
          ),
          bottomRightItem: const ProgressSummaryItem(
            value: '3.8 kg',
            label: 'Remaining',
          ),
        );
    }
  }

  static ProgressChartData _nutritionChart({
    required ProgressRange range,
    required ProgressNutritionMetric nutritionMetric,
  }) {
    switch (nutritionMetric) {
      case ProgressNutritionMetric.calories:
        return ProgressChartData(
          lineColor:
          AppColors.planTrackingProteinBadge,
          spots: _spots(
            range,
            const [
              1820,
              1950,
              1880,
              2010,
              1930,
              1860,
              1980,
            ],
          ),
          bottomLabels: _labels(range),
          minY: 0,
          maxY: 2500,
          interval: 500,
          targetY: 1900,
          tooltipUnit: 'kcal',
        );

      case ProgressNutritionMetric.protein:
        return ProgressChartData(
          lineColor:
          AppColors.planTrackingProteinBadge,
          spots: _spots(
            range,
            const [
              92,
              108,
              101,
              118,
              110,
              121,
              115,
            ],
          ),
          bottomLabels: _labels(range),
          minY: 0,
          maxY: 150,
          interval: 30,
          targetY: 115,
          tooltipUnit: 'g',
        );

      case ProgressNutritionMetric.carbs:
        return ProgressChartData(
          lineColor:
          AppColors.planTrackingProteinBadge,
          spots: _spots(
            range,
            const [
              195,
              220,
              205,
              228,
              214,
              235,
              220,
            ],
          ),
          bottomLabels: _labels(range),
          minY: 0,
          maxY: 300,
          interval: 50,
          targetY: 220,
          tooltipUnit: 'g',
        );

      case ProgressNutritionMetric.fat:
        return ProgressChartData(
          lineColor:
          AppColors.planTrackingProteinBadge,
          spots: _spots(
            range,
            const [
              55,
              62,
              59,
              68,
              61,
              66,
              64,
            ],
          ),
          bottomLabels: _labels(range),
          minY: 0,
          maxY: 100,
          interval: 20,
          targetY: 65,
          tooltipUnit: 'g',
        );
    }
  }

  static ProgressChartData _waterChart(
      ProgressRange range,
      ) {
    return ProgressChartData(
      lineColor:
      AppColors.planTrackingActiveDayBadge,
      spots: _spots(
        range,
        const [
          2.0,
          2.3,
          2.1,
          2.6,
          2.4,
          2.7,
          2.5,
        ],
      ),
      bottomLabels: _labels(range),
      minY: 0,
      maxY: 3.5,
      interval: 0.5,
      targetY: 2.5,
      tooltipUnit: 'L',
    );
  }

  static ProgressChartData _workoutChart(
      ProgressRange range,
      ) {
    return ProgressChartData(
      lineColor:
      AppColors.planTrackingStreakBadge,
      spots: _spots(
        range,
        const [
          30,
          42,
          36,
          55,
          40,
          61,
          48,
        ],
      ),
      bottomLabels: _labels(range),
      minY: 0,
      maxY: 70,
      interval: 10,
      targetY: null,
      tooltipUnit: 'min',
    );
  }

  static ProgressChartData _weightChart(
      ProgressRange range,
      ) {
    return ProgressChartData(
      lineColor: AppColors.homeBrown,
      spots: _spots(
        range,
        const [
          72.0,
          71.6,
          71.2,
          70.6,
          70.0,
          69.4,
          68.8,
        ],
      ),
      bottomLabels: _labels(range),
      minY: 64,
      maxY: 74,
      interval: 2,
      targetY: 65,
      tooltipUnit: 'kg',
    );
  }

  static List<FlSpot> _spots(
      ProgressRange range,
      List<double> values,
      ) {
    final labels = _labels(range);

    final count =
    values.length < labels.length
        ? values.length
        : labels.length;

    return List.generate(
      count,
          (index) => FlSpot(
        index.toDouble(),
        values[index],
      ),
    );
  }

  static List<String> _labels(
      ProgressRange range,
      ) {
    switch (range) {
      case ProgressRange.days7:
        return const [
          'Mon',
          'Tue',
          'Wed',
          'Thu',
          'Fri',
          'Sat',
          'Sun',
        ];

      case ProgressRange.days30:
        return const [
          'W1',
          'W2',
          'W3',
          'W4',
          'W5',
          '',
          '',
        ];

      case ProgressRange.days90:
        return const [
          'W1',
          'W3',
          'W5',
          'W7',
          'W9',
          'W11',
          'W13',
        ];

      case ProgressRange.days365:
        return const [
          'Sep',
          'Nov',
          'Jan',
          'Mar',
          'May',
          'Jul',
          'Aug',
        ];
    }
  }

  static String _rangeLabel(
      ProgressRange range,
      ) {
    switch (range) {
      case ProgressRange.days7:
        return 'Last 7 Days';

      case ProgressRange.days30:
        return 'Last 30 Days';

      case ProgressRange.days90:
        return 'Last 90 Days';

      case ProgressRange.days365:
        return 'Last 365 Days';
    }
  }

  static String _targetDays(
      ProgressRange range,
      ) {
    switch (range) {
      case ProgressRange.days7:
        return '6/7';

      case ProgressRange.days30:
        return '24/30';

      case ProgressRange.days90:
        return '71/90';

      case ProgressRange.days365:
        return '286/365';
    }
  }

  static String _nutritionAverage(
      ProgressNutritionMetric metric,
      ) {
    switch (metric) {
      case ProgressNutritionMetric.calories:
        return '1917';

      case ProgressNutritionMetric.protein:
        return '110 g';

      case ProgressNutritionMetric.carbs:
        return '215 g';

      case ProgressNutritionMetric.fat:
        return '63 g';
    }
  }

  static String _nutritionTarget(
      ProgressNutritionMetric metric,
      ) {
    switch (metric) {
      case ProgressNutritionMetric.calories:
        return '1900';

      case ProgressNutritionMetric.protein:
        return '115 g';

      case ProgressNutritionMetric.carbs:
        return '220 g';

      case ProgressNutritionMetric.fat:
        return '65 g';
    }
  }

  static String _nutritionAverageLabel(
      ProgressNutritionMetric metric,
      ) {
    switch (metric) {
      case ProgressNutritionMetric.calories:
        return 'Daily Average Calories';

      case ProgressNutritionMetric.protein:
        return 'Daily Average Protein';

      case ProgressNutritionMetric.carbs:
        return 'Daily Average Carbs';

      case ProgressNutritionMetric.fat:
        return 'Daily Average Fat';
    }
  }
}