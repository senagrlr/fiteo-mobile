import 'package:fiteo_myapp/features/home/data/daily_summary_repository.dart';
import 'package:fiteo_myapp/features/profile/data/plan_tracking_repository.dart';
import 'package:fiteo_myapp/features/reports/data/monthly_report_generator.dart';
import 'package:fiteo_myapp/features/reports/data/report_repository.dart';
import 'package:fiteo_myapp/features/reports/models/monthly_report_cache.dart';
import 'package:fiteo_myapp/features/reports/data/monthly_target_accumulator_repository.dart';
import 'package:fiteo_myapp/features/reports/data/report_period_resolver.dart';

class MonthlyReportGenerationService {
  MonthlyReportGenerationService({
    DailySummaryRepository? dailySummaryRepository,
    PlanTrackingRepository? planTrackingRepository,
    ReportRepository? reportRepository,
    MonthlyReportGenerator? generator,
    MonthlyTargetAccumulatorRepository? targetAccumulatorRepository,
  })  : _dailySummaryRepository =
      dailySummaryRepository ?? DailySummaryRepository(),
        _planTrackingRepository =
            planTrackingRepository ?? PlanTrackingRepository(),
        _reportRepository =
            reportRepository ?? ReportRepository(),
        _generator =
            generator ?? const MonthlyReportGenerator(),
        _targetAccumulatorRepository =
            targetAccumulatorRepository ?? MonthlyTargetAccumulatorRepository();



  final DailySummaryRepository _dailySummaryRepository;
  final PlanTrackingRepository _planTrackingRepository;
  final ReportRepository _reportRepository;
  final MonthlyReportGenerator _generator;
  final MonthlyTargetAccumulatorRepository _targetAccumulatorRepository;

  Future<MonthlyReportCache> generateAndSave({
    required ReportPeriod period,
    required DateTime generatedAt,
    required DateTime availableFrom,
    List<String> reviewParagraphs = const [],
    List<MonthlyPatternCache> patterns = const [],
    MonthlyNextMonthCache nextMonth = const MonthlyNextMonthCache(
      title: '',
      mainFocus: '',
      keepDoing: '',
      improve: '',
      watch: '',
    ),
  }) async {
    final summariesFuture =
    _dailySummaryRepository.getSummariesForPeriod(
      startDate: period.effectiveStart,
      endDate: period.effectiveEnd,
    );

    final previousReportFuture =
    _reportRepository.getMonthlyReport();

    final planTrackingFuture =
    _planTrackingRepository.loadPlanTracking();

    final accumulatorFuture =
    _targetAccumulatorRepository.loadForMonth(
      month: period.calendarStart,
    );

    final summaries = await summariesFuture;
    final previousReport = await previousReportFuture;
    final planTracking = await planTrackingFuture;
    final accumulator = await accumulatorFuture;

    final cache = _generator.generate(
      period: period,
      summaries: summaries,
      generatedAt: generatedAt,
      availableFrom: availableFrom,
      currentPlanActivatedAt: planTracking.planActivatedAt,
      currentExpectedWeeklyWeightChangeKg:
      planTracking.expectedWeeklyWeightChangeKg,
      accumulator: accumulator,
      startWeightKg:
      previousReport?.weightPlan.currentWeightKg,
      currentWeightKg: null,
      planStatus: planTracking.planStatus.name,
      planStatusDescription: planTracking.aiNote,
      previousComparisonBasis:
      previousReport?.comparisonBasis,
      previousScore: previousReport?.score,
      reviewParagraphs: reviewParagraphs,
      patterns: patterns,
      nextMonth: nextMonth,
    );

    await _reportRepository.saveMonthlyReport(cache);

    return cache;
  }
}