import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:fiteo_myapp/features/profile/presentation/models/overview_stats.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/plan_tracking_stats.dart';
import 'package:fiteo_myapp/features/reports/models/monthly_report_cache.dart';
import 'package:fiteo_myapp/features/reports/models/weekly_report_cache.dart';

class WeeklyAiInsight {
  final List<String> reviewParagraphs;
  final String focusTitle;
  final String focusDescription;
  final List<String> tips;

  const WeeklyAiInsight({
    required this.reviewParagraphs,
    required this.focusTitle,
    required this.focusDescription,
    required this.tips,
  });
}

class MonthlyAiInsight {
  final List<String> reviewParagraphs;
  final String title;
  final String mainFocus;
  final List<String> tips;

  const MonthlyAiInsight({
    required this.reviewParagraphs,
    required this.title,
    required this.mainFocus,
    required this.tips,
  });
}

class PremiumInsightService {
  static const String _url =
      'https://generatepremiuminsight-3qn3ngl7rq-uc.a.run.app';

  static const Duration _requestTimeout =
  Duration(seconds: 30);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> generateOverviewNote(
      OverviewStats stats,
      ) async {
    final result = await _request(
      type: 'overview',
      data: {
        'fiteoScore': stats.fiteoScore,
        'trackingConsistency': stats.trackingConsistency,
        'goalAchievement': stats.goalAchievement,
        'nutritionAdherence': stats.nutritionAdherence,
        'calorieAdherence': stats.calorieAdherence,
        'waterAdherence': stats.waterAdherence,
        'currentTrackingStreak': stats.currentTrackingStreak,
        'longestTrackingStreak': stats.longestTrackingStreak,
        'currentHydrationStreak': stats.currentHydrationStreak,
        'longestHydrationStreak': stats.longestHydrationStreak,
        'activeDays': stats.activeDays,
        'totalWorkoutMinutes': stats.totalWorkoutMinutes,
        'calorieGoalHitDays': stats.calorieGoalHitDays,
        'proteinGoalHitDays': stats.proteinGoalHitDays,
        'carbsGoalHitDays': stats.carbsGoalHitDays,
        'fatGoalHitDays': stats.fatGoalHitDays,
        'waterGoalHitDays': stats.waterGoalHitDays,
        'balancedDays': stats.balancedDays,
      },
    );

    final note = result?['note']?.toString().trim();

    if (note == null || note.isEmpty) {
      return null;
    }

    return note;
  }

  Future<String?> generatePlanNote(
      PlanTrackingStats stats,
      ) async {
    final result = await _request(
      type: 'plan',
      data: {
        'planActivatedAt': _dateKey(stats.planActivatedAt),
        'planStartWeight': stats.planStartWeight,
        'latestWeight': stats.latestWeight,
        'latestWeightDate': stats.latestWeightDate == null
            ? null
            : _dateKey(stats.latestWeightDate!),
        'targetWeight': stats.targetWeight,
        'weightUnit': stats.weightUnit,
        'weightEntryCount': stats.weightEntryCount,
        'expectedWeeklyWeightChangeKg':
        stats.expectedWeeklyWeightChangeKg,
        'actualWeeklyWeightChangeKg':
        stats.actualWeeklyWeightChangeKg,
        'progressRatio': stats.progressRatio,
        'planEligibleDays': stats.planEligibleDays,
        'calorieTrackedDays': stats.calorieTrackedDays,
        'calorieAdherence': stats.calorieAdherence,
        'trackingConsistency': stats.trackingConsistency,
        'expectedGoalDate': stats.expectedGoalDate == null
            ? null
            : _dateKey(stats.expectedGoalDate!),
        'estimatedGoalDate': stats.estimatedGoalDate == null
            ? null
            : _dateKey(stats.estimatedGoalDate!),
        'projectionDifferenceDays':
        stats.projectionDifferenceDays,
        'planStatus': stats.planStatus.name,
      },
    );

    final note = result?['note']?.toString().trim();

    if (note == null || note.isEmpty) {
      return null;
    }

    return note;
  }

  Future<WeeklyAiInsight?> generateWeeklyInsight(
      WeeklyReportCache cache,
      ) async {
    final result = await _request(
      type: 'weekly',
      data: {
        'periodStart': _dateKey(cache.periodStart),
        'periodEnd': _dateKey(cache.periodEnd),
        'score': cache.score,
        'previousScore': cache.previousScore,
        'scoreChange': cache.scoreChange,
        'scoreLevel': cache.scoreLevel.name,
        'overview': {
          'calories': cache.overview.calories.name,
          'protein': cache.overview.protein.name,
          'carbs': cache.overview.carbs.name,
          'fat': cache.overview.fat.name,
          'hydration': cache.overview.hydration.name,
          'activity': cache.overview.activity.name,
        },
        'metrics': {
          'caloriesAverage':
          cache.metrics.caloriesAverage,
          'calorieTargetDays':
          cache.metrics.calorieTargetDays,
          'calorieEvaluatedDays':
          cache.metrics.calorieEvaluatedDays,
          'activeDays':
          cache.metrics.activeDays,
          'totalWorkoutMinutes':
          cache.metrics.totalWorkoutMinutes,
          'proteinAverage':
          cache.metrics.proteinAverage,
          'proteinTargetDays':
          cache.metrics.proteinTargetDays,
          'proteinEvaluatedDays':
          cache.metrics.proteinEvaluatedDays,
        },
        'bestDay': _weeklyDay(cache.bestDay),
        'worstDay': _weeklyDay(cache.worstDay),
      },
    );

    if (result == null) {
      return null;
    }

    final reviewParagraphs = _stringList(
      result['reviewParagraphs'],
      maxItems: 2,
    );

    final nextWeek = Map<String, dynamic>.from(
      result['nextWeek'] as Map? ?? {},
    );

    final focusTitle =
        nextWeek['focusTitle']?.toString().trim() ?? '';

    final focusDescription =
        nextWeek['focusDescription']?.toString().trim() ?? '';

    final tips = _stringList(
      nextWeek['tips'],
      maxItems: 3,
    );

    if (reviewParagraphs.isEmpty ||
        focusTitle.isEmpty ||
        focusDescription.isEmpty ||
        tips.isEmpty) {
      return null;
    }

    return WeeklyAiInsight(
      reviewParagraphs: reviewParagraphs,
      focusTitle: focusTitle,
      focusDescription: focusDescription,
      tips: tips,
    );
  }

  Future<MonthlyAiInsight?> generateMonthlyInsight(
      MonthlyReportCache cache,
      ) async {
    final result = await _request(
      type: 'monthly',
      data: {
        'periodStart': _dateKey(cache.periodStart),
        'periodEnd': _dateKey(cache.periodEnd),
        'score': cache.score,
        'previousScore': cache.previousScore,
        'scoreChange': cache.scoreChange,
        'scoreLevel': cache.scoreLevel.name,
        'metrics': {
          'caloriesAverage':
          cache.metrics.caloriesAverage,
          'calorieTargetDays':
          cache.metrics.calorieTargetDays,
          'calorieEvaluatedDays':
          cache.metrics.calorieEvaluatedDays,
          'activeDays':
          cache.metrics.activeDays,
          'totalWorkoutMinutes':
          cache.metrics.totalWorkoutMinutes,
          'proteinAverage':
          cache.metrics.proteinAverage,
          'proteinTargetDays':
          cache.metrics.proteinTargetDays,
          'proteinEvaluatedDays':
          cache.metrics.proteinEvaluatedDays,
        },
        'consistency': {
          'trackingConsistency':
          cache.consistency.trackingConsistency,
          'trackedDays':
          cache.consistency.trackedDays,
          'eligibleDays':
          cache.consistency.eligibleDays,
          'goalConsistency':
          cache.consistency.goalConsistency,
          'longestTrackingStreak':
          cache.consistency.longestTrackingStreak,
          'perfectDays':
          cache.consistency.perfectDays,
        },
        'strongestArea':
        _monthlyArea(cache.strongestArea),
        'weakestArea':
        _monthlyArea(cache.weakestArea),
        'changes': cache.changes
            .map(
              (change) => {
            'type': change.type.name,
            'difference': change.difference,
            'direction': change.direction.name,
          },
        )
            .toList(),
        'weightPlan': {
          'startWeightKg':
          cache.weightPlan.startWeightKg,
          'currentWeightKg':
          cache.weightPlan.currentWeightKg,
          'monthlyTargetChangeKg':
          cache.weightPlan.monthlyTargetChangeKg,
          'progressAchievedPercent':
          cache.weightPlan.progressAchievedPercent,
          'planStatus':
          cache.weightPlan.planStatus,
        },
      },
    );

    if (result == null) {
      return null;
    }

    final reviewParagraphs = _stringList(
      result['reviewParagraphs'],
      maxItems: 2,
    );

    final nextMonth = Map<String, dynamic>.from(
      result['nextMonth'] as Map? ?? {},
    );

    final title =
        nextMonth['title']?.toString().trim() ?? '';

    final mainFocus =
        nextMonth['mainFocus']?.toString().trim() ?? '';

    final tips = _stringList(
      nextMonth['tips'],
      maxItems: 3,
    );

    if (reviewParagraphs.isEmpty ||
        title.isEmpty ||
        mainFocus.isEmpty ||
        tips.isEmpty) {
      return null;
    }

    return MonthlyAiInsight(
      reviewParagraphs: reviewParagraphs,
      title: title,
      mainFocus: mainFocus,
      tips: tips,
    );
  }

  Future<Map<String, dynamic>?> _request({
    required String type,
    required Map<String, dynamic> data,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      return null;
    }

    try {
      final token = await user.getIdToken();

      if (token == null || token.isEmpty) {
        return null;
      }

      final response = await http
          .post(
        Uri.parse(_url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'type': type,
          'languageCode': _languageCode(),
          'data': data,
        }),
      )
          .timeout(_requestTimeout);

      if (response.statusCode != 200) {
        return null;
      }

      final decoded =
      jsonDecode(response.body) as Map<String, dynamic>;

      return decoded;
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic>? _weeklyDay(dynamic day) {
    if (day == null) {
      return null;
    }

    return {
      'date': _dateKey(day.date),
      'alignmentPercent': day.alignmentPercent,
      'caloriesAligned': day.caloriesAligned,
      'activityAligned': day.activityAligned,
      'waterAligned': day.waterAligned,
      'proteinAligned': day.proteinAligned,
    };
  }

  Map<String, dynamic>? _monthlyArea(dynamic area) {
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

  List<String> _stringList(
      dynamic raw, {
        required int maxItems,
      }) {
    return (raw as List? ?? const [])
        .map((item) => item.toString().trim())
        .where((item) => item.isNotEmpty)
        .take(maxItems)
        .toList();
  }

  String _languageCode() {
    final locale = Intl.getCurrentLocale();

    return locale
        .split(RegExp('[-_]'))
        .first
        .toLowerCase();
  }

  String _dateKey(DateTime date) {
    return '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}