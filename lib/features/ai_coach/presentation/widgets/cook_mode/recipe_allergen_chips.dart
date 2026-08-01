import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';

class RecipeAllergenChips extends StatelessWidget {
  final List<String> allergens;

  const RecipeAllergenChips({
    super.key,
    required this.allergens,
  });

  @override
  Widget build(BuildContext context) {
    if (allergens.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F6F4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFEAE5DF),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Allergens',
            style: TextStyle(
              color: Color(0xFF7D7670),
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 11),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: allergens.map((allergen) {
              final data = _allergenData(allergen);

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFFE5E1DC),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      data.emoji,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      data.label,
                      style: const TextStyle(
                        color: AppColors.homeBrown,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 11),

          const Text(
            'AI-generated allergen information. Always check ingredient labels before consuming.',
            style: TextStyle(
              color: Color(0xFF9A938C),
              fontSize: 10,
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  _AllergenData _allergenData(String allergen) {
    switch (allergen.trim().toLowerCase()) {
      case 'gluten':
        return const _AllergenData(label: 'Gluten', emoji: '🌾');

      case 'milk':
      case 'dairy':
      case 'milk products':
        return const _AllergenData(label: 'Dairy', emoji: '🥛');

      case 'egg':
      case 'eggs':
        return const _AllergenData(label: 'Egg', emoji: '🥚');

      case 'peanut':
      case 'peanuts':
        return const _AllergenData(label: 'Peanuts', emoji: '🥜');

      case 'tree nuts':
      case 'nuts':
        return const _AllergenData(label: 'Tree nuts', emoji: '🌰');

      case 'soy':
      case 'soya':
        return const _AllergenData(label: 'Soy', emoji: '🫘');

      case 'fish':
        return const _AllergenData(label: 'Fish', emoji: '🐟');

      case 'shellfish':
      case 'crustaceans':
        return const _AllergenData(label: 'Shellfish', emoji: '🦐');

      case 'sesame':
        return const _AllergenData(label: 'Sesame', emoji: '🌱');

      default:
        return _AllergenData(
          label: allergen,
          emoji: '⚠️',
        );
    }
  }
}

class _AllergenData {
  final String label;
  final String emoji;

  const _AllergenData({
    required this.label,
    required this.emoji,
  });
}