import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fiteo_myapp/features/reports/models/monthly_report_cache.dart';
import 'package:fiteo_myapp/features/reports/models/monthly_report_calculation.dart';
import 'package:fiteo_myapp/features/reports/models/report_comparison_basis.dart';
import 'package:fiteo_myapp/features/reports/models/weekly_report_cache.dart';
import 'package:fiteo_myapp/features/reports/models/weekly_report_calculation.dart';
import 'package:fiteo_myapp/features/reports/models/report_performance_level.dart';

class ReportCacheSerializer {
  const ReportCacheSerializer();

  Map<String, dynamic> weeklyToMap(WeeklyReportCache cache) {
    return {
      'schemaVersion': cache.schemaVersion,
      'periodStart': Timestamp.fromDate(cache.periodStart),
      'periodEnd': Timestamp.fromDate(cache.periodEnd),
      'generatedAt': Timestamp.fromDate(cache.generatedAt),
      'availableFrom': Timestamp.fromDate(cache.availableFrom),
      'isAvailable': cache.isAvailable,
      'dismissed': cache.dismissed,
      'dismissedAt': _timestampOrNull(cache.dismissedAt),
      'emailSentAt': _timestampOrNull(cache.emailSentAt),
      'score': cache.score,
      'previousScore': cache.previousScore,
      'scoreChange': cache.scoreChange,
      'scoreLevel': cache.scoreLevel.name,
      'overview': _weeklyOverviewToMap(cache.overview),
      'metrics': _weeklyMetricsToMap(cache.metrics),
      'bestDay': _weeklyDayToMap(cache.bestDay),
      'worstDay': _weeklyDayToMap(cache.worstDay),
      'weightPlan': {
        'startWeightKg': cache.weightPlan.startWeightKg,
        'currentWeightKg': cache.weightPlan.currentWeightKg,
        'planStatus': cache.weightPlan.planStatus,
        'planStatusDescription': cache.weightPlan.planStatusDescription,
      },
      'reviewParagraphs': cache.reviewParagraphs,
      'nextWeek': {
        'focusTitle': cache.nextWeek.focusTitle,
        'focusDescription': cache.nextWeek.focusDescription,
        'tips': cache.nextWeek.tips,
      },
    };
  }

  WeeklyReportCache weeklyFromMap(Map<String, dynamic> data) {
    final weightPlan =
    Map<String, dynamic>.from(data['weightPlan'] as Map? ?? {});

    final nextWeek =
    Map<String, dynamic>.from(data['nextWeek'] as Map? ?? {});

    return WeeklyReportCache(
      schemaVersion: (data['schemaVersion'] as num?)?.round() ?? 1,
      periodStart: _dateTime(data['periodStart']),
      periodEnd: _dateTime(data['periodEnd']),
      generatedAt: _dateTime(data['generatedAt']),
      availableFrom: _dateTime(data['availableFrom']),
      isAvailable: data['isAvailable'] as bool? ?? false,
      dismissed: data['dismissed'] as bool? ?? false,
      dismissedAt: _nullableDateTime(data['dismissedAt']),
      emailSentAt: _nullableDateTime(data['emailSentAt']),
      score: (data['score'] as num?)?.round() ?? 0,
      previousScore: (data['previousScore'] as num?)?.round(),
      scoreChange: (data['scoreChange'] as num?)?.round(),
      scoreLevel: _performanceLevel(data['scoreLevel']),
      overview: _weeklyOverviewFromMap(data['overview']),
      metrics: _weeklyMetricsFromMap(data['metrics']),
      bestDay: _weeklyDayFromMap(data['bestDay']),
      worstDay: _weeklyDayFromMap(data['worstDay']),
      weightPlan: WeeklyWeightPlanCache(
        startWeightKg:
        (weightPlan['startWeightKg'] as num?)?.toDouble(),
        currentWeightKg:
        (weightPlan['currentWeightKg'] as num?)?.toDouble(),
        planStatus: weightPlan['planStatus'] as String? ?? 'notEnoughData',
        planStatusDescription:
        weightPlan['planStatusDescription'] as String?,
      ),
      reviewParagraphs: List<String>.from(
        data['reviewParagraphs'] as List? ?? const [],
      ),
      nextWeek: WeeklyNextWeekCache(
        focusTitle: nextWeek['focusTitle'] as String? ?? '',
        focusDescription: nextWeek['focusDescription'] as String? ?? '',
        tips: List<String>.from(
          nextWeek['tips'] as List? ?? const [],
        ),
      ),
    );
  }

  MonthlyReportCache monthlyFromMap(Map<String, dynamic> data) {
    final weightPlan =
    Map<String, dynamic>.from(data['weightPlan'] as Map? ?? {});

    final nextMonth =
    Map<String, dynamic>.from(data['nextMonth'] as Map? ?? {});

    final changesRaw =
        data['changes'] as List? ?? const [];

    return MonthlyReportCache(
      schemaVersion: (data['schemaVersion'] as num?)?.round() ?? 1,
      periodStart: _dateTime(data['periodStart']),
      periodEnd: _dateTime(data['periodEnd']),
      generatedAt: _dateTime(data['generatedAt']),
      availableFrom: _dateTime(data['availableFrom']),
      isAvailable: data['isAvailable'] as bool? ?? false,
      dismissed: data['dismissed'] as bool? ?? false,
      dismissedAt: _nullableDateTime(data['dismissedAt']),
      emailSentAt: _nullableDateTime(data['emailSentAt']),
      score: (data['score'] as num?)?.round() ?? 0,
      previousScore: (data['previousScore'] as num?)?.round(),
      scoreChange: (data['scoreChange'] as num?)?.round(),
      scoreLevel: _performanceLevel(data['scoreLevel']),
      metrics: _monthlyMetricsFromMap(data['metrics']),
      consistency: _monthlyConsistencyFromMap(data['consistency']),
      strongestArea: _monthlyAreaFromMap(data['strongestArea']),
      weakestArea: _monthlyAreaFromMap(data['weakestArea']),
      changes: changesRaw
          .whereType<Map>()
          .map(
            (item) => _monthlyChangeFromMap(
          Map<String, dynamic>.from(item),
        ),
      )
          .toList(),
      weightPlan: MonthlyWeightPlanCache(
        startWeightKg:
        (weightPlan['startWeightKg'] as num?)?.toDouble(),
        currentWeightKg:
        (weightPlan['currentWeightKg'] as num?)?.toDouble(),
        monthlyTargetChangeKg:
        (weightPlan['monthlyTargetChangeKg'] as num?)?.toDouble(),
        progressAchievedPercent:
        (weightPlan['progressAchievedPercent'] as num?)?.round(),
        planStatus: weightPlan['planStatus'] as String? ?? 'notEnoughData',
        planStatusDescription:
        weightPlan['planStatusDescription'] as String?,
      ),
      reviewParagraphs: List<String>.from(
        data['reviewParagraphs'] as List? ?? const [],
      ),
      nextMonth: MonthlyNextMonthCache(
        title: nextMonth['title'] as String? ?? '',
        mainFocus: nextMonth['mainFocus'] as String? ?? '',
        keepDoing: nextMonth['keepDoing'] as String? ?? '',
        improve: nextMonth['improve'] as String? ?? '',
        watch: nextMonth['watch'] as String? ?? '',
      ),
      comparisonBasis: _comparisonBasisFromMap(
        data['comparisonBasis'],
      ),
    );
  }

  Map<String, dynamic> monthlyToMap(MonthlyReportCache cache) {
    return {
      'schemaVersion': cache.schemaVersion,
      'periodStart': Timestamp.fromDate(cache.periodStart),
      'periodEnd': Timestamp.fromDate(cache.periodEnd),
      'generatedAt': Timestamp.fromDate(cache.generatedAt),
      'availableFrom': Timestamp.fromDate(cache.availableFrom),
      'isAvailable': cache.isAvailable,
      'dismissed': cache.dismissed,
      'dismissedAt': _timestampOrNull(cache.dismissedAt),
      'emailSentAt': _timestampOrNull(cache.emailSentAt),
      'score': cache.score,
      'previousScore': cache.previousScore,
      'scoreChange': cache.scoreChange,
      'scoreLevel': cache.scoreLevel.name,
      'metrics': _monthlyMetricsToMap(cache.metrics),
      'consistency': _monthlyConsistencyToMap(cache.consistency),
      'strongestArea': _monthlyAreaToMap(cache.strongestArea),
      'weakestArea': _monthlyAreaToMap(cache.weakestArea),
      'changes': cache.changes.map(_monthlyChangeToMap).toList(),
      'weightPlan': {
        'startWeightKg': cache.weightPlan.startWeightKg,
        'currentWeightKg': cache.weightPlan.currentWeightKg,
        'monthlyTargetChangeKg': cache.weightPlan.monthlyTargetChangeKg,
        'progressAchievedPercent':
        cache.weightPlan.progressAchievedPercent,
        'planStatus': cache.weightPlan.planStatus,
        'planStatusDescription': cache.weightPlan.planStatusDescription,
      },
      'reviewParagraphs': cache.reviewParagraphs,
      'nextMonth': {
        'title': cache.nextMonth.title,
        'mainFocus': cache.nextMonth.mainFocus,
        'keepDoing': cache.nextMonth.keepDoing,
        'improve': cache.nextMonth.improve,
        'watch': cache.nextMonth.watch,
      },
      'comparisonBasis': _comparisonBasisToMap(cache.comparisonBasis),
    };
  }

  Map<String, dynamic> _weeklyOverviewToMap(
      WeeklyOverviewCalculation overview,
      ) {
    return {
      'calories': overview.calories.name,
      'protein': overview.protein.name,
      'carbs': overview.carbs.name,
      'fat': overview.fat.name,
      'hydration': overview.hydration.name,
      'activity': overview.activity.name,
    };
  }

  Map<String, dynamic> _weeklyMetricsToMap(
      WeeklyMetricsCalculation metrics,
      ) {
    return {
      'caloriesAverage': metrics.caloriesAverage,
      'calorieTargetDays': metrics.calorieTargetDays,
      'calorieEvaluatedDays': metrics.calorieEvaluatedDays,
      'activeDays': metrics.activeDays,
      'totalWorkoutMinutes': metrics.totalWorkoutMinutes,
      'proteinAverage': metrics.proteinAverage,
      'proteinTargetDays': metrics.proteinTargetDays,
      'proteinEvaluatedDays': metrics.proteinEvaluatedDays,
    };
  }

  Map<String, dynamic>? _weeklyDayToMap(
      WeeklyDayCalculation? day,
      ) {
    if (day == null) {
      return null;
    }

    return {
      'date': Timestamp.fromDate(day.date),
      'alignmentPercent': day.alignmentPercent,
      'caloriesAligned': day.caloriesAligned,
      'activityAligned': day.activityAligned,
      'waterAligned': day.waterAligned,
      'proteinAligned': day.proteinAligned,
    };
  }

  Map<String, dynamic> _monthlyMetricsToMap(
      MonthlyMetricsCalculation metrics,
      ) {
    return {
      'caloriesAverage': metrics.caloriesAverage,
      'calorieTargetDays': metrics.calorieTargetDays,
      'calorieEvaluatedDays': metrics.calorieEvaluatedDays,
      'activeDays': metrics.activeDays,
      'totalWorkoutMinutes': metrics.totalWorkoutMinutes,
      'proteinAverage': metrics.proteinAverage,
      'proteinTargetDays': metrics.proteinTargetDays,
      'proteinEvaluatedDays': metrics.proteinEvaluatedDays,
    };
  }

  Map<String, dynamic> _monthlyConsistencyToMap(
      MonthlyConsistencyCalculation consistency,
      ) {
    return {
      'trackingConsistency': consistency.trackingConsistency,
      'trackedDays': consistency.trackedDays,
      'eligibleDays': consistency.eligibleDays,
      'goalConsistency': consistency.goalConsistency,
      'longestTrackingStreak': consistency.longestTrackingStreak,
      'perfectDays': consistency.perfectDays,
    };
  }

  Map<String, dynamic>? _monthlyAreaToMap(
      MonthlyAreaCalculation? area,
      ) {
    if (area == null) {
      return null;
    }

    return {
      'type': area.type.name,
      'score': area.score,
      'targetDays': area.targetDays,
      'evaluatedDays': area.evaluatedDays,
      'weekdayAverage': area.weekdayAverage,
      'weekendAverage': area.weekendAverage,
      'weekendDifference': area.weekendDifference,
    };
  }

  Map<String, dynamic> _monthlyChangeToMap(
      MonthlyChangeCalculation change,
      ) {
    return {
      'type': change.type.name,
      'difference': change.difference,
      'direction': change.direction.name,
    };
  }

  Map<String, dynamic> _comparisonBasisToMap(
      ReportComparisonBasis basis,
      ) {
    return {
      'trackingConsistency': basis.trackingConsistency,
      'goalConsistency': basis.goalConsistency,
      'calorieTargetDays': basis.calorieTargetDays,
      'proteinTargetDays': basis.proteinTargetDays,
      'hydrationTargetDays': basis.hydrationTargetDays,
      'activeDays': basis.activeDays,
    };
  }

  Timestamp? _timestampOrNull(DateTime? value) {
    return value == null ? null : Timestamp.fromDate(value);
  }

  WeeklyOverviewCalculation _weeklyOverviewFromMap(dynamic raw) {
    final data = Map<String, dynamic>.from(raw as Map? ?? {});

    return WeeklyOverviewCalculation(
      calories: _performanceLevel(data['calories']),
      protein: _performanceLevel(data['protein']),
      carbs: _performanceLevel(data['carbs']),
      fat: _performanceLevel(data['fat']),
      hydration: _performanceLevel(data['hydration']),
      activity: _performanceLevel(data['activity']),
    );
  }

  WeeklyMetricsCalculation _weeklyMetricsFromMap(dynamic raw) {
    final data = Map<String, dynamic>.from(raw as Map? ?? {});

    return WeeklyMetricsCalculation(
      caloriesAverage:
      (data['caloriesAverage'] as num?)?.toDouble() ?? 0,
      calorieTargetDays:
      (data['calorieTargetDays'] as num?)?.round() ?? 0,
      calorieEvaluatedDays:
      (data['calorieEvaluatedDays'] as num?)?.round() ?? 0,
      activeDays:
      (data['activeDays'] as num?)?.round() ?? 0,
      totalWorkoutMinutes:
      (data['totalWorkoutMinutes'] as num?)?.round() ?? 0,
      proteinAverage:
      (data['proteinAverage'] as num?)?.toDouble() ?? 0,
      proteinTargetDays:
      (data['proteinTargetDays'] as num?)?.round() ?? 0,
      proteinEvaluatedDays:
      (data['proteinEvaluatedDays'] as num?)?.round() ?? 0,
    );
  }

  WeeklyDayCalculation? _weeklyDayFromMap(dynamic raw) {
    if (raw is! Map) return null;

    final data = Map<String, dynamic>.from(raw);

    return WeeklyDayCalculation(
      date: _dateTime(data['date']),
      alignmentPercent:
      (data['alignmentPercent'] as num?)?.round() ?? 0,
      caloriesAligned: data['caloriesAligned'] as bool?,
      activityAligned: data['activityAligned'] as bool?,
      waterAligned: data['waterAligned'] as bool?,
      proteinAligned: data['proteinAligned'] as bool?,
    );
  }

  MonthlyMetricsCalculation _monthlyMetricsFromMap(dynamic raw) {
    final data = Map<String, dynamic>.from(raw as Map? ?? {});

    return MonthlyMetricsCalculation(
      caloriesAverage:
      (data['caloriesAverage'] as num?)?.toDouble() ?? 0,
      calorieTargetDays:
      (data['calorieTargetDays'] as num?)?.round() ?? 0,
      calorieEvaluatedDays:
      (data['calorieEvaluatedDays'] as num?)?.round() ?? 0,
      activeDays:
      (data['activeDays'] as num?)?.round() ?? 0,
      totalWorkoutMinutes:
      (data['totalWorkoutMinutes'] as num?)?.round() ?? 0,
      proteinAverage:
      (data['proteinAverage'] as num?)?.toDouble() ?? 0,
      proteinTargetDays:
      (data['proteinTargetDays'] as num?)?.round() ?? 0,
      proteinEvaluatedDays:
      (data['proteinEvaluatedDays'] as num?)?.round() ?? 0,
    );
  }

  MonthlyConsistencyCalculation _monthlyConsistencyFromMap(dynamic raw) {
    final data = Map<String, dynamic>.from(raw as Map? ?? {});

    return MonthlyConsistencyCalculation(
      trackingConsistency:
      (data['trackingConsistency'] as num?)?.toDouble() ?? 0,
      trackedDays:
      (data['trackedDays'] as num?)?.round() ?? 0,
      eligibleDays:
      (data['eligibleDays'] as num?)?.round() ?? 0,
      goalConsistency:
      (data['goalConsistency'] as num?)?.toDouble() ?? 0,
      longestTrackingStreak:
      (data['longestTrackingStreak'] as num?)?.round() ?? 0,
      perfectDays:
      (data['perfectDays'] as num?)?.round() ?? 0,
    );
  }

  MonthlyAreaCalculation? _monthlyAreaFromMap(dynamic raw) {
    if (raw is! Map) return null;

    final data = Map<String, dynamic>.from(raw);

    return MonthlyAreaCalculation(
      type: MonthlyAreaType.values.firstWhere(
            (value) => value.name == data['type'],
        orElse: () => MonthlyAreaType.tracking,
      ),
      score: (data['score'] as num?)?.toDouble() ?? 0,
      targetDays: (data['targetDays'] as num?)?.round(),
      evaluatedDays: (data['evaluatedDays'] as num?)?.round(),
      weekdayAverage:
      (data['weekdayAverage'] as num?)?.toDouble(),
      weekendAverage:
      (data['weekendAverage'] as num?)?.toDouble(),
      weekendDifference:
      (data['weekendDifference'] as num?)?.toDouble(),
    );
  }

  MonthlyChangeCalculation _monthlyChangeFromMap(
      Map<String, dynamic> data,
      ) {
    return MonthlyChangeCalculation(
      type: MonthlyChangeType.values.firstWhere(
            (value) => value.name == data['type'],
        orElse: () => MonthlyChangeType.trackingConsistency,
      ),
      difference:
      (data['difference'] as num?)?.toDouble() ?? 0,
      direction: MonthlyCalculationChangeDirection.values.firstWhere(
            (value) => value.name == data['direction'],
        orElse: () => MonthlyCalculationChangeDirection.same,
      ),
    );
  }

  ReportComparisonBasis _comparisonBasisFromMap(dynamic raw) {
    final data = Map<String, dynamic>.from(raw as Map? ?? {});

    return ReportComparisonBasis(
      trackingConsistency:
      (data['trackingConsistency'] as num?)?.toDouble() ?? 0,
      goalConsistency:
      (data['goalConsistency'] as num?)?.toDouble() ?? 0,
      calorieTargetDays:
      (data['calorieTargetDays'] as num?)?.round() ?? 0,
      proteinTargetDays:
      (data['proteinTargetDays'] as num?)?.round() ?? 0,
      hydrationTargetDays:
      (data['hydrationTargetDays'] as num?)?.round() ?? 0,
      activeDays:
      (data['activeDays'] as num?)?.round() ?? 0,
    );
  }

  ReportPerformanceLevel _performanceLevel(dynamic raw) {
    return ReportPerformanceLevel.values.firstWhere(
          (value) => value.name == raw,
      orElse: () => ReportPerformanceLevel.needsImprovement,
    );
  }

  DateTime _dateTime(dynamic raw) {
    if (raw is Timestamp) {
      return raw.toDate();
    }

    if (raw is DateTime) {
      return raw;
    }

    if (raw is String) {
      return DateTime.tryParse(raw) ??
          DateTime.fromMillisecondsSinceEpoch(0);
    }

    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  DateTime? _nullableDateTime(dynamic raw) {
    if (raw == null) return null;

    return _dateTime(raw);
  }
}