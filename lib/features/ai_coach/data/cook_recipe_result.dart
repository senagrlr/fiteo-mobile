class CookRecipeIngredient {
  final String name;
  final String amount;
  final int calories;

  const CookRecipeIngredient({
    required this.name,
    required this.amount,
    required this.calories,
  });

  factory CookRecipeIngredient.fromJson(Map<String, dynamic> json) {
    return CookRecipeIngredient(
      name: json['name'] ?? '',
      amount: json['amount'] ?? '',
      calories: (json['calories'] as num?)?.round() ?? 0,
    );
  }
}

class CookRecipeResult {
  final String recipeName;
  final List<CookRecipeIngredient> ingredients;
  final List<String> instructions;
  final int totalCalories;
  final int servings;
  final int caloriesPerServing;

  const CookRecipeResult({
    required this.recipeName,
    required this.ingredients,
    required this.instructions,
    required this.totalCalories,
    required this.servings,
    required this.caloriesPerServing,
  });

  factory CookRecipeResult.fromJson(Map<String, dynamic> json) {
    return CookRecipeResult(
      recipeName: json['recipeName'] ?? 'Generated Recipe',
      ingredients: ((json['ingredients'] as List?) ?? [])
          .map((item) => CookRecipeIngredient.fromJson(
        Map<String, dynamic>.from(item),
      ))
          .toList(),
      instructions: ((json['instructions'] as List?) ?? [])
          .map((item) => item.toString())
          .toList(),
      totalCalories: (json['totalCalories'] as num?)?.round() ?? 0,
      servings: (json['servings'] as num?)?.round() ?? 1,
      caloriesPerServing:
      (json['caloriesPerServing'] as num?)?.round() ?? 0,
    );
  }

  String toDisplayText() {
    final buffer = StringBuffer();

    buffer.writeln(recipeName);
    buffer.writeln();
    buffer.writeln('Ingredients:');

    for (final ingredient in ingredients) {
      final amountText =
      ingredient.amount.isEmpty ? '' : '${ingredient.amount} ';
      buffer.writeln(
        '- $amountText${ingredient.name} (${ingredient.calories} kcal)',
      );
    }

    buffer.writeln();
    buffer.writeln('Instructions:');

    for (int i = 0; i < instructions.length; i++) {
      buffer.writeln('${i + 1}. ${instructions[i]}');
    }

    buffer.writeln();
    buffer.writeln('Servings: $servings');
    buffer.writeln('Total calories: $totalCalories kcal');
    buffer.writeln('Calories per serving: $caloriesPerServing kcal');

    return buffer.toString();
  }
}