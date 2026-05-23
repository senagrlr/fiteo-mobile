import 'dart:convert';

import 'package:http/http.dart' as http;

class NutritionApiResult {
  final String name;
  final num caloriesPer100g;

  const NutritionApiResult({
    required this.name,
    required this.caloriesPer100g,
  });
}

class NutritionApiService {

  static const String _baseUrl =
      'https://searchfoodcalories-3qn3ngl7rq-uc.a.run.app';

  Future<NutritionApiResult?> searchFood({
    required String query,
    required String foodType,
  }) async {
    final encodedQuery = Uri.encodeQueryComponent(query);
    final encodedFoodType = Uri.encodeQueryComponent(foodType);

    final uri = Uri.parse(
      '$_baseUrl?q=$encodedQuery&foodType=$encodedFoodType',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      return null;
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;

    return NutritionApiResult(
      name: decoded['name'] as String,
      caloriesPer100g: decoded['caloriesPer100g'] as num,
    );
  }
}