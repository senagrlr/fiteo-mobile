class NutritionFood {
  final String id;
  final String name;

  final double caloriesPer100g;
  final double proteinPer100g;
  final double fatPer100g;
  final double carbsPer100g;

  final List<NutritionServing> servings;

  final String source;
  final bool isEstimated;
  final String? foodType;
  final String? confidence;

  const NutritionFood({
    required this.id,
    required this.name,
    required this.caloriesPer100g,
    required this.proteinPer100g,
    required this.fatPer100g,
    required this.carbsPer100g,
    this.servings = const [],
    required this.source,
    this.isEstimated = false,
    this.foodType,
    this.confidence,
  });

  NutritionValues calculateForGrams(double grams) {
    final multiplier = grams / 100;

    return NutritionValues(
      calories: caloriesPer100g * multiplier,
      protein: proteinPer100g * multiplier,
      fat: fatPer100g * multiplier,
      carbs: carbsPer100g * multiplier,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'caloriesPer100g': caloriesPer100g,
      'proteinPer100g': proteinPer100g,
      'fatPer100g': fatPer100g,
      'carbsPer100g': carbsPer100g,
      'servings': servings.map((serving) => serving.toMap()).toList(),
      'source': source,
      'isEstimated': isEstimated,
      'foodType': foodType,
      'confidence': confidence,
    };
  }

  factory NutritionFood.fromMap(Map<String, dynamic> map) {
    final servingsData = map['servings'] as List<dynamic>? ?? [];

    return NutritionFood(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      caloriesPer100g: (map['caloriesPer100g'] as num?)?.toDouble() ?? 0,
      proteinPer100g: (map['proteinPer100g'] as num?)?.toDouble() ?? 0,
      fatPer100g: (map['fatPer100g'] as num?)?.toDouble() ?? 0,
      carbsPer100g: (map['carbsPer100g'] as num?)?.toDouble() ?? 0,
      servings: servingsData
          .whereType<Map<String, dynamic>>()
          .map(NutritionServing.fromMap)
          .toList(),
      source: map['source'] as String? ?? 'unknown',
      isEstimated: map['isEstimated'] as bool? ?? false,
      foodType: map['foodType'] as String?,
      confidence: map['confidence'] as String?,
    );
  }
}

class NutritionServing {
  final String id;
  final String description;

  final double calories;
  final double protein;
  final double fat;
  final double carbs;

  const NutritionServing({
    required this.id,
    required this.description,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
  });

  NutritionValues calculateForAmount(double amount) {
    return NutritionValues(
      calories: calories * amount,
      protein: protein * amount,
      fat: fat * amount,
      carbs: carbs * amount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'carbs': carbs,
    };
  }

  factory NutritionServing.fromMap(Map<String, dynamic> map) {
    return NutritionServing(
      id: map['id'] as String? ?? '',
      description: map['description'] as String? ?? '',
      calories: (map['calories'] as num?)?.toDouble() ?? 0,
      protein: (map['protein'] as num?)?.toDouble() ?? 0,
      fat: (map['fat'] as num?)?.toDouble() ?? 0,
      carbs: (map['carbs'] as num?)?.toDouble() ?? 0,
    );
  }
}

class NutritionValues {
  final double calories;
  final double protein;
  final double fat;
  final double carbs;

  const NutritionValues({
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
  });
}