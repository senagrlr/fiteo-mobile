import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:fiteo_myapp/features/meals/data/fatsecret_candidate_ranker.dart';

class FatSecretServing {
  final String id;
  final String description;
  final double? metricAmount;
  final String? metricUnit;
  final bool isDefault;
  final double calories;
  final double protein;
  final double fat;
  final double carbs;

  const FatSecretServing({
    required this.id,
    required this.description,
    required this.metricAmount,
    required this.metricUnit,
    required this.isDefault,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
  });
}

class FatSecretSearchFood {
  final String id;
  final String name;
  final String? brandName;
  final String? foodType;
  final bool hasPer100gServing;
  final double caloriesPer100g;
  final double proteinPer100g;
  final double fatPer100g;
  final double carbsPer100g;
  final List<FatSecretServing> servings;

  const FatSecretSearchFood({
    required this.id,
    required this.name,
    required this.brandName,
    required this.foodType,
    required this.hasPer100gServing,
    required this.caloriesPer100g,
    required this.proteinPer100g,
    required this.fatPer100g,
    required this.carbsPer100g,
    required this.servings,
  });
}

class FatSecretFoodDetails {
  final String id;
  final String name;
  final String? foodType;
  final bool hasPer100gServing;
  final double caloriesPer100g;
  final double proteinPer100g;
  final double fatPer100g;
  final double carbsPer100g;
  final List<FatSecretServing> servings;

  const FatSecretFoodDetails({
    required this.id,
    required this.name,
    required this.foodType,
    required this.hasPer100gServing,
    required this.caloriesPer100g,
    required this.proteinPer100g,
    required this.fatPer100g,
    required this.carbsPer100g,
    required this.servings,
  });
}

class FatSecretApiService {
  static const String _searchUrl =
      'https://us-central1-fiteo-app-39f91.cloudfunctions.net/searchFatSecretFoods';

  static const String _detailsUrl =
      'https://us-central1-fiteo-app-39f91.cloudfunctions.net/getFatSecretFood';

  static const String _barcodeUrl =
      'https://us-central1-fiteo-app-39f91.cloudfunctions.net/findFatSecretFoodByBarcode';

  double _toDouble(dynamic value) {
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  List<FatSecretServing> _parseServings(dynamic rawServings) {
    if (rawServings == null) return [];

    final List<dynamic> servingList =
    rawServings is List ? rawServings : [rawServings];

    return servingList
        .whereType<Map<String, dynamic>>()
        .map(
          (serving) => FatSecretServing(
        id: serving['serving_id']?.toString() ?? '',
        description: serving['serving_description']?.toString() ?? '',
        metricAmount: double.tryParse(
          serving['metric_serving_amount']?.toString() ?? '',
        ),
        metricUnit: serving['metric_serving_unit']?.toString(),
        isDefault: serving['is_default']?.toString() == '1',
        calories: _toDouble(serving['calories']),
        protein: _toDouble(serving['protein']),
        fat: _toDouble(serving['fat']),
        carbs: _toDouble(serving['carbohydrate']),
      ),
    )
        .toList();
  }

  FatSecretServing? _findPer100gServing(
      List<FatSecretServing> servings,
      ) {
    for (final serving in servings) {
      if (serving.metricAmount == 100 &&
          serving.metricUnit?.toLowerCase() == 'g') {
        return serving;
      }
    }

    return null;
  }

  Future<String?> findFoodIdByBarcode({
    required String barcode,
  }) async {
    final cleanBarcode =
    barcode.replaceAll(RegExp(r'\D'), '');

    if (cleanBarcode.isEmpty) {
      return null;
    }

    final uri = Uri.parse(
      '$_barcodeUrl?barcode=${Uri.encodeQueryComponent(cleanBarcode)}',
    );

    print('FATSECRET BARCODE REQUEST: $uri');

    final response = await http.get(uri);

    print(
      'FATSECRET BARCODE STATUS: ${response.statusCode}',
    );

    if (response.statusCode != 200) {
      print(
        'FATSECRET BARCODE ERROR: ${response.body}',
      );

      return null;
    }

    final decoded =
    jsonDecode(response.body)
    as Map<String, dynamic>;

    if (decoded['error'] != null) {
      print(
        'FATSECRET BARCODE ERROR: ${decoded['error']}',
      );

      return null;
    }

    final foodId =
    decoded['foodId']?.toString();

    if (foodId == null ||
        foodId.trim().isEmpty) {
      return null;
    }

    return foodId.trim();
  }

  Future<List<FatSecretSearchFood>> searchFoods({
    required String query,
  }) async {
    final cleanQuery = query.trim();

    if (cleanQuery.isEmpty) return [];

    final uri = Uri.parse(
      '$_searchUrl?q=${Uri.encodeQueryComponent(cleanQuery)}',
    );

    print('FATSECRET SEARCH REQUEST: $uri');

    final response = await http.get(uri);

    print('FATSECRET SEARCH STATUS: ${response.statusCode}');

    if (response.statusCode != 200) return [];

    final decoded =
    jsonDecode(response.body) as Map<String, dynamic>;

    if (decoded['error'] != null) {
      print('FATSECRET SEARCH ERROR: ${decoded['error']}');
      return [];
    }

    final foodsSearch =
    decoded['foods_search'] as Map<String, dynamic>?;

    final results =
    foodsSearch?['results'] as Map<String, dynamic>?;

    final rawFoods = results?['food'];

    if (rawFoods == null) return [];

    final List<dynamic> foods =
    rawFoods is List ? rawFoods : [rawFoods];

    final parsedFoods = <FatSecretSearchFood>[];

    for (final rawFood in foods) {
      if (rawFood is! Map<String, dynamic>) continue;

      final id = rawFood['food_id']?.toString() ?? '';
      final name = rawFood['food_name']?.toString() ?? '';

      if (id.isEmpty || name.isEmpty) continue;

      final servingsContainer =
      rawFood['servings'] as Map<String, dynamic>?;

      final servings = _parseServings(
        servingsContainer?['serving'],
      );

      final per100g = _findPer100gServing(servings);

      parsedFoods.add(
        FatSecretSearchFood(
          id: id,
          name: name,
          brandName: rawFood['brand_name']?.toString(),
          foodType: rawFood['food_type']?.toString(),
          hasPer100gServing: per100g != null,
          caloriesPer100g: per100g?.calories ?? 0,
          proteinPer100g: per100g?.protein ?? 0,
          fatPer100g: per100g?.fat ?? 0,
          carbsPer100g: per100g?.carbs ?? 0,
          servings: servings,
        ),
      );
    }

    return FatSecretCandidateRanker.rank(
      query: cleanQuery,
      foods: parsedFoods,
    );
  }

  Future<FatSecretFoodDetails?> getFoodDetails({
    required String id,
  }) async {
    final uri = Uri.parse(
      '$_detailsUrl?foodId=${Uri.encodeQueryComponent(id)}',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) return null;

    final decoded =
    jsonDecode(response.body) as Map<String, dynamic>;

    if (decoded['error'] != null) return null;

    final food =
    decoded['food'] as Map<String, dynamic>?;

    if (food == null) return null;

    final servingsContainer =
    food['servings'] as Map<String, dynamic>?;

    final servings = _parseServings(
      servingsContainer?['serving'],
    );

    final per100g = _findPer100gServing(servings);

    return FatSecretFoodDetails(
      id: food['food_id']?.toString() ?? id,
      name: food['food_name']?.toString() ?? '',
      foodType: food['food_type']?.toString(),
      hasPer100gServing: per100g != null,
      caloriesPer100g: per100g?.calories ?? 0,
      proteinPer100g: per100g?.protein ?? 0,
      fatPer100g: per100g?.fat ?? 0,
      carbsPer100g: per100g?.carbs ?? 0,
      servings: servings,
    );
  }
}