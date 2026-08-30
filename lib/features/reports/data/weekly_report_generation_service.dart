import 'package:fiteo_myapp/features/home/data/daily_summary_repository.dart';
import 'package:fiteo_myapp/features/reports/data/report_repository.dart';
import 'package:fiteo_myapp/features/reports/data/weekly_report_generator.dart';
import 'package:fiteo_myapp/features/reports/models/weekly_report_cache.dart';
import 'package:fiteo_myapp/features/reports/data/report_period_resolver.dart';
import 'package:fiteo_myapp/features/ai/data/premium_insight_service.dart';

class WeeklyReportGenerationService {
  WeeklyReportGenerationService({
    DailySummaryRepository? dailySummaryRepository,
    ReportRepository? reportRepository,
    WeeklyReportGenerator? generator,
    PremiumInsightService? premiumInsightService,
  })  : _dailySummaryRepository =
      dailySummaryRepository ?? DailySummaryRepository(),
        _reportRepository =
            reportRepository ?? ReportRepository(),
        _generator =
            generator ?? const WeeklyReportGenerator(),
        _premiumInsightService =
            premiumInsightService ?? PremiumInsightService();

  final DailySummaryRepository _dailySummaryRepository;
  final ReportRepository _reportRepository;
  final WeeklyReportGenerator _generator;
  final PremiumInsightService _premiumInsightService;

  Future<WeeklyReportCache> generateAndSave({
    required ReportPeriod period,
    required DateTime generatedAt,
    required DateTime availableFrom,
    List<String> reviewParagraphs = const [],
    WeeklyNextWeekCache nextWeek =
    const WeeklyNextWeekCache(
      focusTitle: '',
      focusDescription: '',
      tips: [],
    ),
  }) async {
    final summariesFuture =
    _dailySummaryRepository
        .getSummariesForPeriod(
      startDate: period.effectiveStart,
      endDate: period.effectiveEnd,
    );

    final previousReportFuture =
    _reportRepository.getWeeklyReport();

    final summaries = await summariesFuture;
    final previousReport =
    await previousReportFuture;

    final draft = _generator.generate(
      days: summaries,
      period: period,
      generatedAt: generatedAt,
      availableFrom: availableFrom,
      reviewParagraphs:
      reviewParagraphs,
      nextWeek: nextWeek,
      previousScore:
      previousReport?.score,
    );

    var resolvedReviewParagraphs =
        reviewParagraphs;

    var resolvedNextWeek = nextWeek;

    final needsReview =
        resolvedReviewParagraphs.isEmpty;

    final needsNextWeek =
        resolvedNextWeek.focusTitle
            .trim()
            .isEmpty ||
            resolvedNextWeek
                .focusDescription
                .trim()
                .isEmpty ||
            resolvedNextWeek.tips.isEmpty;

    if (needsReview || needsNextWeek) {
      final insight =
      await _premiumInsightService
          .generateWeeklyInsight(
        draft,
      );

      if (insight != null) {
        if (needsReview) {
          resolvedReviewParagraphs =
              insight.reviewParagraphs;
        }

        if (needsNextWeek) {
          resolvedNextWeek =
              WeeklyNextWeekCache(
                focusTitle:
                insight.focusTitle,
                focusDescription:
                insight.focusDescription,
                tips: insight.tips,
              );
        }
      }
    }

    final cache = _generator.generate(
      days: summaries,
      period: period,
      generatedAt: generatedAt,
      availableFrom: availableFrom,
      reviewParagraphs:
      resolvedReviewParagraphs,
      nextWeek: resolvedNextWeek,
      previousScore:
      previousReport?.score,
    );

    await _reportRepository
        .saveWeeklyReport(cache);

    return cache;
  }
}