class CookRecipeIngredient {
  final String name;
  final String amount;
  final int calories;

  const CookRecipeIngredient({
    required this.name,
    required this.amount,
    required this.calories,
  });

  factory CookRecipeIngredient.fromJson(
      Map<String, dynamic> json,
      ) {
    return CookRecipeIngredient(
      name: json['name']?.toString() ?? '',
      amount: json['amount']?.toString() ?? '',
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
  final List<String> allergens;

  const CookRecipeResult({
    required this.recipeName,
    required this.ingredients,
    required this.instructions,
    required this.totalCalories,
    required this.servings,
    required this.caloriesPerServing,
    this.allergens = const [],
  });

  factory CookRecipeResult.fromJson(
      Map<String, dynamic> json,
      ) {
    final ingredients =
    ((json['ingredients'] as List?) ?? [])
        .map(
          (item) => CookRecipeIngredient.fromJson(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList();

    final apiAllergens =
    ((json['allergens'] as List?) ?? [])
        .map((item) => item.toString())
        .where((item) => item.trim().isNotEmpty)
        .toList();

    final allergens = apiAllergens.isNotEmpty
        ? _normalizeAllergens(apiAllergens)
        : _detectAllergensFromIngredients(ingredients);

    return CookRecipeResult(
      recipeName:
      json['recipeName']?.toString() ?? 'Generated Recipe',
      ingredients: ingredients,
      instructions:
      ((json['instructions'] as List?) ?? [])
          .map((item) => item.toString())
          .toList(),
      totalCalories:
      (json['totalCalories'] as num?)?.round() ?? 0,
      servings:
      (json['servings'] as num?)?.round() ?? 1,
      caloriesPerServing:
      (json['caloriesPerServing'] as num?)?.round() ?? 0,
      allergens: allergens,
    );
  }

  static List<String> _normalizeAllergens(
      List<String> allergens,
      ) {
    final normalized = <String>{};

    for (final allergen in allergens) {
      final value = allergen.trim().toLowerCase();

      switch (value) {
        case 'gluten':
        case 'wheat':
        case 'barley':
        case 'rye':
          normalized.add('Gluten');
          break;

        case 'milk':
        case 'dairy':
        case 'milk products':
        case 'lactose':
          normalized.add('Dairy');
          break;

        case 'egg':
        case 'eggs':
          normalized.add('Egg');
          break;

        case 'peanut':
        case 'peanuts':
          normalized.add('Peanuts');
          break;

        case 'tree nut':
        case 'tree nuts':
        case 'nuts':
          normalized.add('Tree nuts');
          break;

        case 'soy':
        case 'soya':
          normalized.add('Soy');
          break;

        case 'fish':
          normalized.add('Fish');
          break;

        case 'shellfish':
        case 'crustaceans':
        case 'shrimp':
        case 'prawn':
          normalized.add('Shellfish');
          break;

        case 'sesame':
          normalized.add('Sesame');
          break;

        default:
          normalized.add(allergen.trim());
      }
    }

    return normalized.toList();
  }

  static List<String> _detectAllergensFromIngredients(
      List<CookRecipeIngredient> ingredients,
      ) {
    final detected = <String>{};

    for (final ingredient in ingredients) {
      final name = ingredient.name.toLowerCase();

      if (_containsAny(name, const [
        'wheat',
        'flour',
        'bread',
        'pasta',
        'noodle',
        'couscous',
        'bulgur',
        'barley',
        'rye',
        'seitan',
      ])) {
        detected.add('Gluten');
      }

      if (_containsAny(name, const [
        'milk',
        'cheese',
        'cream',
        'butter',
        'yogurt',
        'yoghurt',
        'whey',
        'casein',
        'mozzarella',
        'parmesan',
        'cheddar',
      ])) {
        detected.add('Dairy');
      }

      if (_containsAny(name, const [
        'egg',
        'eggs',
        'mayonnaise',
        'meringue',
      ])) {
        detected.add('Egg');
      }

      if (_containsAny(name, const [
        'peanut',
        'peanuts',
        'groundnut',
      ])) {
        detected.add('Peanuts');
      }

      if (_containsAny(name, const [
        'almond',
        'walnut',
        'hazelnut',
        'cashew',
        'pistachio',
        'pecan',
        'macadamia',
        'brazil nut',
      ])) {
        detected.add('Tree nuts');
      }

      if (_containsAny(name, const [
        'soy',
        'soya',
        'tofu',
        'tempeh',
        'edamame',
        'miso',
      ])) {
        detected.add('Soy');
      }

      if (_containsAny(name, const [
        'salmon',
        'tuna',
        'cod',
        'anchovy',
        'sardine',
        'fish',
      ])) {
        detected.add('Fish');
      }

      if (_containsAny(name, const [
        'shrimp',
        'prawn',
        'crab',
        'lobster',
        'shellfish',
        'crayfish',
      ])) {
        detected.add('Shellfish');
      }

      if (_containsAny(name, const [
        'sesame',
        'tahini',
      ])) {
        detected.add('Sesame');
      }
    }

    return detected.toList();
  }

  static bool _containsAny(
      String value,
      List<String> keywords,
      ) {
    return keywords.any(value.contains);
  }

  String toDisplayText() {
    final buffer = StringBuffer();

    buffer.writeln(recipeName);
    buffer.writeln();
    buffer.writeln('Ingredients:');

    for (final ingredient in ingredients) {
      final amountText = ingredient.amount.isEmpty
          ? ''
          : '${ingredient.amount} ';

      buffer.writeln(
        '- $amountText${ingredient.name} '
            '(${ingredient.calories} kcal)',
      );
    }

    if (allergens.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('Allergens:');

      for (final allergen in allergens) {
        buffer.writeln('- $allergen');
      }
    }

    buffer.writeln();
    buffer.writeln('Instructions:');

    for (int i = 0; i < instructions.length; i++) {
      buffer.writeln(
        '${i + 1}. ${instructions[i]}',
      );
    }

    buffer.writeln();
    buffer.writeln('Servings: $servings');
    buffer.writeln(
      'Total calories: $totalCalories kcal',
    );
    buffer.writeln(
      'Calories per serving: '
          '$caloriesPerServing kcal',
    );

    return buffer.toString();
  }
}