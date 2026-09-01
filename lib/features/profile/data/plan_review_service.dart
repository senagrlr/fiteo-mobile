import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'package:fiteo_myapp/features/profile/data/plan_tracking_calculator.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/plan_tracking_stats.dart';

class ReviewedPlanData {
  final int calories;
  final int proteinGrams;
  final int carbsGrams;
  final int fatsGrams;
  final int waterMl;
  final double tdee;
  final double expectedWeeklyWeightChangeKg;

  const ReviewedPlanData({
    required this.calories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatsGrams,
    required this.waterMl,
    required this.tdee,
    required this.expectedWeeklyWeightChangeKg,
  });
}

class PlanReviewResult {
  final ReviewedPlanData previousPlan;
  final ReviewedPlanData newPlan;

  const PlanReviewResult({
    required this.previousPlan,
    required this.newPlan,
  });
}

class PlanReviewService {
  static const String _url =
      'https://us-central1-fiteo-app-39f91.cloudfunctions.net/calculateReviewedPlan';

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final PlanTrackingCalculator _calculator =
  const PlanTrackingCalculator();

  Future<PlanReviewResult> calculateReview(
      PlanTrackingStats stats,
      ) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception(
        'User not logged in',
      );
    }

    final actual =
        stats.actualWeeklyWeightChangeKg;

    if (actual == null) {
      throw Exception(
        'Missing actual weight change',
      );
    }

    final userDoc =
    await _firestore
        .collection('users')
        .doc(user.uid)
        .get();

    final userData =
        userDoc.data() ??
            <String, dynamic>{};

    final preferences =
    Map<String, dynamic>.from(
      userData['userPreferences']
      as Map<String, dynamic>? ??
          {},
    );

    final nutritionPlan =
    Map<String, dynamic>.from(
      userData['nutritionPlan']
      as Map<String, dynamic>? ??
          {},
    );

    final currentCalories =
    (nutritionPlan['dailyCalories']
    as num?)
        ?.toDouble();

    final protein =
    (nutritionPlan['proteinGrams']
    as num?)
        ?.round();

    final carbs =
    (nutritionPlan['carbsGrams']
    as num?)
        ?.round();

    final fats =
    (nutritionPlan['fatsGrams']
    as num?)
        ?.round();

    final water =
    (nutritionPlan['waterMl']
    as num?)
        ?.round();

    if (currentCalories == null ||
        protein == null ||
        carbs == null ||
        fats == null ||
        water == null) {
      throw Exception(
        'Current nutrition plan is missing',
      );
    }

    final currentWeight =
        stats.latestWeight ??
            (preferences['weight'] as num?)
                ?.toDouble() ??
            stats.planStartWeight;

    preferences['weight'] =
        currentWeight;

    final delta =
    _calculator
        .calculateReviewCalorieDeltaKcal(
      expectedWeeklyWeightChangeKg:
      stats.expectedWeeklyWeightChangeKg,
      actualWeeklyWeightChangeKg:
      actual,
    );

    final token =
    await user.getIdToken();

    if (token == null ||
        token.isEmpty) {
      throw Exception(
        'Missing auth token',
      );
    }

    final response =
    await http
        .post(
      Uri.parse(_url),
      headers: {
        'Authorization':
        'Bearer $token',
        'Content-Type':
        'application/json',
      },
      body: jsonEncode({
        'userPreferences':
        preferences,
        'currentCalories':
        currentCalories,
        'adjustmentDeltaKcal':
        delta,
      }),
    )
        .timeout(
      const Duration(
        seconds: 30,
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Reviewed plan calculation failed',
      );
    }

    final decoded =
    jsonDecode(response.body)
    as Map<String, dynamic>;

    final plan =
    decoded['plan']
    as Map<String, dynamic>?;

    if (plan == null) {
      throw Exception(
        'Missing reviewed plan',
      );
    }

    return PlanReviewResult(
      previousPlan:
      ReviewedPlanData(
        calories:
        currentCalories.round(),
        proteinGrams: protein,
        carbsGrams: carbs,
        fatsGrams: fats,
        waterMl: water,
        tdee: 0,
        expectedWeeklyWeightChangeKg:
        stats.expectedWeeklyWeightChangeKg,
      ),
      newPlan:
      ReviewedPlanData(
        calories:
        (plan['calories'] as num)
            .round(),
        proteinGrams:
        (plan['proteinGrams'] as num)
            .round(),
        carbsGrams:
        (plan['carbsGrams'] as num)
            .round(),
        fatsGrams:
        (plan['fatsGrams'] as num)
            .round(),
        waterMl:
        (plan['waterMl'] as num)
            .round(),
        tdee:
        (plan['tdee'] as num)
            .toDouble(),
        expectedWeeklyWeightChangeKg:
        (plan[
        'expectedWeeklyWeightChangeKg'
        ] as num)
            .toDouble(),
      ),
    );
  }
}