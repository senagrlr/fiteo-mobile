import 'package:fiteo_myapp/features/home/data/daily_summary_repository.dart';
import 'package:fiteo_myapp/features/reports/data/report_repository.dart';
import 'package:fiteo_myapp/features/reports/data/weekly_report_generator.dart';
import 'package:fiteo_myapp/features/reports/models/weekly_report_cache.dart';
import 'package:fiteo_myapp/features/reports/data/report_period_resolver.dart';

class WeeklyReportGenerationService {
  WeeklyReportGenerationService({
    DailySummaryRepository? dailySummaryRepository,
    ReportRepository? reportRepository,
    WeeklyReportGenerator? generator,
  })  : _dailySummaryRepository =
      dailySummaryRepository ?? DailySummaryRepository(),
        _reportRepository =
            reportRepository ?? ReportRepository(),
        _generator =
            generator ?? const WeeklyReportGenerator();

  final DailySummaryRepository _dailySummaryRepository;
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

    final summaries = await summariesFuture;
    final previousReport = await previousReportFuture;

    final cache = _generator.generate(
      days: summaries,
      period: period,
      generatedAt: generatedAt,
      availableFrom: availableFrom,
      reviewParagraphs: reviewParagraphs,
      nextWeek: nextWeek,
      previousScore: previousReport?.score,
    );

    await _reportRepository.saveWeeklyReport(cache);

    return cache;
  }
}