import 'package:fiteo_myapp/features/profile/data/plan_tracking_calculator.dart';
import 'package:fiteo_myapp/features/profile/data/weight_repository.dart';

class PlanTrackingWeightResult {
  final int weightEntryCount;
  final double? latestWeight;
  final DateTime? latestWeightDate;
  final double? actualWeeklyWeightChangeKg;
  final double? progressRatio;
  final DateTime? estimatedGoalDate;
  final int? projectionDifferenceDays;
  final List<PlanWeightPoint> weightPoints;

  const PlanTrackingWeightResult({
    required this.weightEntryCount,
    required this.latestWeight,
    required this.latestWeightDate,
    required this.actualWeeklyWeightChangeKg,
    required this.progressRatio,
    required this.estimatedGoalDate,
    required this.projectionDifferenceDays,
    required this.weightPoints,
  });
}

class PlanTrackingWeightService {
  final WeightRepository _weightRepository;
  final PlanTrackingCalculator _calculator;

  PlanTrackingWeightService({
    WeightRepository? weightRepository,
    PlanTrackingCalculator? calculator,
  })  : _weightRepository =
      weightRepository ?? WeightRepository(),
        _calculator =
            calculator ?? const PlanTrackingCalculator();

  Future<bool> needsRefresh({
    required DateTime planActivatedAt,
    required DateTime? cachedLatestWeightDate,
    required double? cachedLatestWeight,
  }) async {
    final trackingState =
    await _weightRepository.getTrackingState();

    final sourceLatestDate =
        trackingState.latestWeightDate;

    final sourceLatestWeight =
        trackingState.latestWeightKg;

    if (sourceLatestDate == null) {
      return cachedLatestWeightDate != null ||
          cachedLatestWeight != null;
    }

    final belongsToCurrentPlan =
    !sourceLatestDate.isBefore(
      planActivatedAt,
    );

    if (!belongsToCurrentPlan) {
      return cachedLatestWeightDate != null ||
          cachedLatestWeight != null;
    }

    if (cachedLatestWeightDate == null ||
        cachedLatestWeight == null) {
      return true;
    }

    final sameDate =
        sourceLatestDate.year ==
            cachedLatestWeightDate.year &&
            sourceLatestDate.month ==
                cachedLatestWeightDate.month &&
            sourceLatestDate.day ==
                cachedLatestWeightDate.day;

    final sameWeight =
        sourceLatestWeight ==
            cachedLatestWeight;

    return !sameDate || !sameWeight;
  }

  Future<PlanTrackingWeightResult> calculate({
    required DateTime planActivatedAt,
    required double planStartWeight,
    required double targetWeight,
    required double expectedWeeklyWeightChangeKg,
    required DateTime today,
    required int observationDays,
  }) async {
    final entries =
    await _weightRepository.getEntries(
      start: planActivatedAt,
      end: today,
    );

    final initialEstimatedGoalDate =
    _calculator
        .calculateInitialEstimatedGoalDate(
      planStartWeight:
      planStartWeight,
      targetWeight:
      targetWeight,
      expectedWeeklyWeightChangeKg:
      expectedWeeklyWeightChangeKg,
      planActivatedAt:
      planActivatedAt,
    );

    if (entries.isEmpty) {
      return PlanTrackingWeightResult(
        weightEntryCount: 0,
        latestWeight: null,
        latestWeightDate: null,
        actualWeeklyWeightChangeKg: null,
        progressRatio: null,
        estimatedGoalDate: initialEstimatedGoalDate,
        projectionDifferenceDays: null,
        weightPoints: const [],
      );
    }

    final sortedEntries = [...entries]
      ..sort(
            (a, b) =>
            a.date.compareTo(b.date),
      );

    final latestEntry =
        sortedEntries.last;

    final weightPoints = sortedEntries
        .map((entry) => PlanWeightPoint(
      date: entry.date,
      weightKg: entry.weightKg,
    ))
        .toList();

    double? actualWeeklyWeightChangeKg;

    if (weightPoints.length >= 2) {
      actualWeeklyWeightChangeKg =
          _calculator.calculateLinearRegressionWeeklyRate(weightPoints);
    }

    final progressRatio =
    _calculator.calculateProgressRatio(
      expectedWeeklyWeightChangeKg:
      expectedWeeklyWeightChangeKg,
      actualWeeklyWeightChangeKg:
      actualWeeklyWeightChangeKg,
    );

    final hasEnoughWeightData =
        weightPoints.length >=
            PlanTrackingCalculator
                .minWeightEntries &&
            observationDays >=
                PlanTrackingCalculator
                    .minObservationDays &&
            actualWeeklyWeightChangeKg != null;

    DateTime? estimatedGoalDate =
        initialEstimatedGoalDate;

    int? projectionDifferenceDays;

    if (hasEnoughWeightData) {
      final actualEstimatedGoalDate =
      _calculator
          .calculateEstimatedGoalDate(
        latestWeight:
        latestEntry.weightKg,
        targetWeight:
        targetWeight,
        actualWeeklyWeightChangeKg:
        actualWeeklyWeightChangeKg,
        latestWeightDate:
        latestEntry.date,
      );

      estimatedGoalDate =
          actualEstimatedGoalDate;

      projectionDifferenceDays =
          _calculator
              .calculateProjectionDifferenceDays(
            previousEstimate:
            initialEstimatedGoalDate,
            newEstimate:
            actualEstimatedGoalDate,
          );
    }

    return PlanTrackingWeightResult(
      weightEntryCount: weightPoints.length,
      latestWeight: latestEntry.weightKg,
      latestWeightDate: latestEntry.date,
      actualWeeklyWeightChangeKg: actualWeeklyWeightChangeKg,
      progressRatio: progressRatio,
      estimatedGoalDate: estimatedGoalDate,
      projectionDifferenceDays: projectionDifferenceDays,
      weightPoints: weightPoints,
    );
  }
}