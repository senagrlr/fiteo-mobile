import 'package:fiteo_myapp/features/home/data/daily_summary_repository.dart';
import 'package:fiteo_myapp/features/profile/data/plan_tracking_repository.dart';
import 'package:fiteo_myapp/features/reports/data/monthly_report_generator.dart';
import 'package:fiteo_myapp/features/reports/data/report_repository.dart';
import 'package:fiteo_myapp/features/reports/models/monthly_report_cache.dart';
import 'package:fiteo_myapp/features/reports/data/monthly_target_accumulator_repository.dart';
import 'package:fiteo_myapp/features/reports/data/report_period_resolver.dart';
import 'package:fiteo_myapp/features/profile/data/weight_repository.dart';
import 'package:fiteo_myapp/features/reports/data/monthly_weight_resolver.dart';

class MonthlyReportGenerationService {
  MonthlyReportGenerationService({
    DailySummaryRepository? dailySummaryRepository,
    PlanTrackingRepository? planTrackingRepository,
    ReportRepository? reportRepository,
    MonthlyReportGenerator? generator,
    MonthlyTargetAccumulatorRepository? targetAccumulatorRepository,
    WeightRepository? weightRepository,
    MonthlyWeightResolver? weightResolver,
  })  : _dailySummaryRepository =
      dailySummaryRepository ?? DailySummaryRepository(),
        _planTrackingRepository =
            planTrackingRepository ?? PlanTrackingRepository(),
        _reportRepository =
            reportRepository ?? ReportRepository(),
        _generator =
            generator ?? const MonthlyReportGenerator(),
        _targetAccumulatorRepository =
            targetAccumulatorRepository ?? MonthlyTargetAccumulatorRepository(),
        _weightRepository =
            weightRepository ?? WeightRepository(),
        _weightResolver =
            weightResolver ?? const MonthlyWeightResolver();



  final DailySummaryRepository _dailySummaryRepository;
  final PlanTrackingRepository _planTrackingRepository;
  final ReportRepository _reportRepository;
  final MonthlyReportGenerator _generator;
  final MonthlyTargetAccumulatorRepository _targetAccumulatorRepository;
  final WeightRepository _weightRepository;
  final MonthlyWeightResolver _weightResolver;

  Future<MonthlyReportCache> generateAndSave({
    required ReportPeriod period,
    required DateTime generatedAt,
    required DateTime availableFrom,
    List<String> reviewParagraphs = const [],
    MonthlyNextMonthCache nextMonth = const MonthlyNextMonthCache(
      title: '',
      mainFocus: '',
      tips: [],
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

    final weightEntriesFuture =
    _weightRepository.getEntries(
      start: period.calendarStart,
      end: period.calendarEnd,
    );

    final summaries = await summariesFuture;
    final previousReport = await previousReportFuture;
    final planTracking = await planTrackingFuture;
    final accumulator = await accumulatorFuture;
    final weightEntries = await weightEntriesFuture;

    final weightResolution = _weightResolver.resolve(
      periodStart: period.calendarStart,
      periodEnd: period.calendarEnd,
      planActivatedAt:
      planTracking.planActivatedAt,
      planStartWeightKg:
      planTracking.planStartWeight,
      currentMonthEntries:
      weightEntries,
      previousReport:
      previousReport,
    );

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
      weightResolution.startWeightKg,
      currentWeightKg:
      weightResolution.currentWeightKg,
      planStatus: planTracking.planStatus.name,
      planStatusDescription: planTracking.aiNote,
      previousComparisonBasis:
      previousReport?.comparisonBasis,
      previousScore: previousReport?.score,
      reviewParagraphs: reviewParagraphs,
      nextMonth: nextMonth,
    );

    await _reportRepository.saveMonthlyReport(cache);

    return cache;
  }
}