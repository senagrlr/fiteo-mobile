import 'dart:convert';

import 'package:http/http.dart' as http;

class FoodNormalizationResult {
  final String normalizedName;
  final String searchQuery;
  final String foodType;

  const FoodNormalizationResult({
    required this.normalizedName,
    required this.searchQuery,
    required this.foodType,
  });

  factory FoodNormalizationResult.fromJson(Map<String, dynamic> json) {
    return FoodNormalizationResult(
      normalizedName: json['normalizedName'] ?? '',
      searchQuery: json['searchQuery'] ?? '',
      foodType: json['foodType'] ?? 'unknown',
    );
  }
}

class FoodCalorieEstimateResult {
  final num caloriesPer100g;
  final String confidence;

  const FoodCalorieEstimateResult({
    required this.caloriesPer100g,
    required this.confidence,
  });

  factory FoodCalorieEstimateResult.fromJson(Map<String, dynamic> json) {
    return FoodCalorieEstimateResult(
      caloriesPer100g: json['caloriesPer100g'] ?? 0,
      confidence: json['confidence'] ?? 'low',
    );
  }
}

class ExerciseClassificationResult {
  final String exerciseId;
  final String exerciseName;
  final String confidence;

  const ExerciseClassificationResult({
    required this.exerciseId,
    required this.exerciseName,
    required this.confidence,
  });

  factory ExerciseClassificationResult.fromJson(
      Map<String, dynamic> json,
      ) {
    return ExerciseClassificationResult(
      exerciseId: json['exerciseId'] ?? '',
      exerciseName: json['exerciseName'] ?? '',
      confidence: json['confidence'] ?? 'low',
    );
  }
}

class AiService {
  static const String _normalizeFoodUrl =
      'https://normalizefoodname-3qn3ngl7rq-uc.a.run.app';
  static const String _estimateCaloriesUrl =
      'https://estimatefoodcalories-3qn3ngl7rq-uc.a.run.app';
  static const String _classifyExerciseUrl =
      'https://classifyexercise-3qn3ngl7rq-uc.a.run.app';

  Future<FoodNormalizationResult?> normalizeFoodName(String input) async {
    final trimmedInput = input.trim();

    if (trimmedInput.isEmpty) return null;

    try {
      final encodedQuery = Uri.encodeQueryComponent(trimmedInput);

      final uri = Uri.parse(
        '$_normalizeFoodUrl?q=$encodedQuery',
      );

      final response = await http.get(uri);

      if (response.statusCode != 200) {
        final fallback = trimmedInput.toLowerCase();

        return FoodNormalizationResult(
          normalizedName: fallback,
          searchQuery: fallback,
          foodType: 'unknown',
        );
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;

      return FoodNormalizationResult.fromJson(decoded);
    } catch (_) {
      final fallback = trimmedInput.toLowerCase();

      return FoodNormalizationResult(
        normalizedName: fallback,
        searchQuery: fallback,
        foodType: 'unknown',
      );
    }
  }

  Future<FoodCalorieEstimateResult?> estimateFoodCaloriesPer100g({
    required String foodName,
  }) async {
    final trimmedInput = foodName.trim();

    if (trimmedInput.isEmpty) return null;

    try {
      final encodedFood =
      Uri.encodeQueryComponent(trimmedInput);

      final uri = Uri.parse(
        '$_estimateCaloriesUrl?food=$encodedFood',
      );

      final response = await http.get(uri);

      if (response.statusCode != 200) {
        return null;
      }

      final decoded =
      jsonDecode(response.body)
      as Map<String, dynamic>;

      return FoodCalorieEstimateResult.fromJson(
        decoded,
      );
    } catch (_) {
      return null;
    }
  }

  Future<ExerciseClassificationResult?> classifyExercise({
    required String input,
    required List<Map<String, dynamic>> exercises,
  }) async {
    final trimmedInput = input.trim();

    if (trimmedInput.isEmpty || exercises.isEmpty) {
      return null;
    }

    try {
      final uri = Uri.parse(_classifyExerciseUrl);

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'input': trimmedInput,
          'exercises': exercises,
        }),
      );

      if (response.statusCode != 200) {
        return null;
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;

      return ExerciseClassificationResult.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }
}