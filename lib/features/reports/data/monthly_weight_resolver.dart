import 'package:fiteo_myapp/features/profile/data/weight_repository.dart';
import 'package:fiteo_myapp/features/reports/models/monthly_report_cache.dart';

class MonthlyWeightResolution {
  final double? startWeightKg;
  final double? currentWeightKg;

  const MonthlyWeightResolution({
    required this.startWeightKg,
    required this.currentWeightKg,
  });
}

class MonthlyWeightResolver {
  const MonthlyWeightResolver();

  MonthlyWeightResolution resolve({
    required DateTime periodStart,
    required DateTime periodEnd,
    required DateTime planActivatedAt,
    required double planStartWeightKg,
    required List<WeightEntry> currentMonthEntries,
    required MonthlyReportCache? previousReport,
  }) {
    final validEntries = currentMonthEntries
        .where((entry) => entry.weightKg > 0)
        .toList()
      ..sort(
            (first, second) =>
            first.date.compareTo(second.date),
      );

    final firstCurrentMonthEntry =
    validEntries.isEmpty
        ? null
        : validEntries.first.weightKg;

    final lastCurrentMonthEntry =
    validEntries.isEmpty
        ? null
        : validEntries.last.weightKg;

    final isPlanStartMonth =
        planActivatedAt.year == periodStart.year &&
            planActivatedAt.month == periodStart.month;

    final previousMonthStart =
    DateTime(
      periodStart.year,
      periodStart.month - 1,
      1,
    );

    final previousReportIsImmediatePreviousMonth =
        previousReport != null &&
            previousReport.periodStart.year ==
                previousMonthStart.year &&
            previousReport.periodStart.month ==
                previousMonthStart.month;

    double? startWeightKg;

    if (isPlanStartMonth) {
      startWeightKg =
      planStartWeightKg > 0
          ? planStartWeightKg
          : firstCurrentMonthEntry;
    } else if (previousReportIsImmediatePreviousMonth &&
        previousReport!
            .weightPlan
            .currentWeightKg !=
            null) {
      startWeightKg =
          previousReport
              .weightPlan
              .currentWeightKg;
    } else {
      startWeightKg =
      validEntries.length >= 2
          ? firstCurrentMonthEntry
          : null;
    }

    return MonthlyWeightResolution(
      startWeightKg: startWeightKg,
      currentWeightKg:
      lastCurrentMonthEntry,
    );
  }
}