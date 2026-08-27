import 'package:fiteo_myapp/features/home/data/daily_summary_repository.dart';
import 'package:fiteo_myapp/features/profile/data/plan_tracking_repository.dart';
import 'package:fiteo_myapp/features/reports/data/report_repository.dart';
import 'package:fiteo_myapp/features/reports/data/weekly_report_generator.dart';
import 'package:fiteo_myapp/features/reports/models/weekly_report_cache.dart';
import 'package:fiteo_myapp/features/reports/data/report_period_resolver.dart';

class WeeklyReportGenerationService {
  WeeklyReportGenerationService({
    DailySummaryRepository? dailySummaryRepository,
    PlanTrackingRepository? planTrackingRepository,
    ReportRepository? reportRepository,
    WeeklyReportGenerator? generator,
  })  : _dailySummaryRepository =
      dailySummaryRepository ?? DailySummaryRepository(),
        _planTrackingRepository =
            planTrackingRepository ?? PlanTrackingRepository(),
        _reportRepository =
            reportRepository ?? ReportRepository(),
        _generator =
            generator ?? const WeeklyReportGenerator();

  final DailySummaryRepository _dailySummaryRepository;
  final PlanTrackingRepository _planTrackingRepository;
  final ReportRepository _reportRepository;
  final WeeklyReportGenerator _generator;

  Future<WeeklyReportCache> generateAndSave({
    required ReportPeriod period,
    required DateTime generatedAt,
    required DateTime availableFrom,
    List<String> reviewParagraphs = const [],
    WeeklyNextWeekCache nextWeek = const WeeklyNextWeekCache(
      focusTitle: '',
      focusDescription: '',
      tips: [],
    ),
  }) async {
    final summariesFuture =
    _dailySummaryRepository.getSummariesForPeriod(
      startDate: period.effectiveStart,
      endDate: period.effectiveEnd,
    );

    final previousReportFuture =
    _reportRepository.getWeeklyReport();

    final planTrackingFuture =
    _planTrackingRepository.loadPlanTracking();

    final summaries = await summariesFuture;
    final previousReport = await previousReportFuture;
    final planTracking = await planTrackingFuture;

    final weightPlan = WeeklyWeightPlanCache(
      startWeightKg: previousReport?.weightPlan.currentWeightKg,
      currentWeightKg: null,
      planStatus: planTracking.planStatus.name,
      planStatusDescription: planTracking.aiNote,
    );

    final cache = _generator.generate(
      days: summaries,
      period: period,
      generatedAt: generatedAt,
      availableFrom: availableFrom,
      weightPlan: weightPlan,
      reviewParagraphs: reviewParagraphs,
      nextWeek: nextWeek,
      previousScore: previousReport?.score,
    );

    await _reportRepository.saveWeeklyReport(cache);

    return cache;
  }
}