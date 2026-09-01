import 'package:fiteo_myapp/features/reports/data/monthly_report_generation_service.dart';
import 'package:fiteo_myapp/features/reports/data/report_period_resolver.dart';
import 'package:fiteo_myapp/features/reports/data/weekly_report_generation_service.dart';
import 'package:fiteo_myapp/features/reports/models/monthly_report_cache.dart';
import 'package:fiteo_myapp/features/reports/models/weekly_report_cache.dart';

class ReportGenerationCoordinator {
  ReportGenerationCoordinator({
    ReportPeriodResolver resolver = const ReportPeriodResolver(),
    WeeklyReportGenerationService? weeklyService,
    MonthlyReportGenerationService? monthlyService,
  })  : _resolver = resolver,
        _weeklyService =
            weeklyService ?? WeeklyReportGenerationService(),
        _monthlyService =
            monthlyService ?? MonthlyReportGenerationService();

  final ReportPeriodResolver _resolver;
  final WeeklyReportGenerationService _weeklyService;
  final MonthlyReportGenerationService _monthlyService;

  Future<WeeklyReportCache?> generatePreviousCompletedWeek({
    required DateTime referenceDate,
    required DateTime userStartedAt,
    required DateTime availableFrom,
  }) async {
    final today = _dateOnly(referenceDate);

    final currentWeekStart = today.subtract(
      Duration(
        days: today.weekday - DateTime.monday,
      ),
    );

    final previousWeekEnd = currentWeekStart.subtract(
      const Duration(days: 1),
    );

    final period = _resolver.weekly(
      periodEnd: previousWeekEnd,
      userStartedAt: userStartedAt,
    );

    if (period.eligibleDays <= 0) {
      return null;
    }

    return _weeklyService.generateAndSave(
      period: period,
      generatedAt: referenceDate,
      availableFrom: availableFrom,
    );
  }

  Future<MonthlyReportCache?> generatePreviousCompletedMonth({
    required DateTime referenceDate,
    required DateTime userStartedAt,
    required DateTime availableFrom,
  }) async {
    final today = _dateOnly(referenceDate);

    final previousMonth = DateTime(
      today.year,
      today.month - 1,
      1,
    );

    final period = _resolver.monthly(
      year: previousMonth.year,
      month: previousMonth.month,
      userStartedAt: userStartedAt,
    );

    if (period.eligibleDays <= 0) {
      return null;
    }

    return _monthlyService.generateAndSave(
      period: period,
      generatedAt: referenceDate,
      availableFrom: availableFrom,
    );
  }

  DateTime _dateOnly(DateTime value) {
    return DateTime(
      value.year,
      value.month,
      value.day,
    );
  }
}