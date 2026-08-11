import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';

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
        color: AppColors.allergenCardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.allergenCardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.allergens,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.homeSecondaryValue,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 11),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: allergens.map((allergen) {
              final data = _allergenData(
                context,
                allergen,
              );

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppColors.allergenChipBorder,
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
                      style: AppTextStyles.bodyMedium.copyWith(
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

          Text(
            context.l10n.allergenDisclaimer,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.homeSecondaryValue,
              fontSize: 10,
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  _AllergenData _allergenData(
      BuildContext context,
      String allergen,
      ) {
    switch (allergen.trim().toLowerCase()) {
      case 'gluten':
        return _AllergenData(
          label: context.l10n.allergenGluten,
          emoji: '🌾',
        );

      case 'milk':
      case 'dairy':
      case 'milk products':
        return _AllergenData(
          label: context.l10n.allergenDairy,
          emoji: '🥛',
        );

      case 'egg':
      case 'eggs':
        return _AllergenData(
          label: context.l10n.allergenEgg,
          emoji: '🥚',
        );

      case 'peanut':
      case 'peanuts':
        return _AllergenData(
          label: context.l10n.allergenPeanuts,
          emoji: '🥜',
        );

      case 'tree nuts':
      case 'nuts':
        return _AllergenData(
          label: context.l10n.allergenTreeNuts,
          emoji: '🌰',
        );

      case 'soy':
      case 'soya':
        return _AllergenData(
          label: context.l10n.allergenSoy,
          emoji: '🫘',
        );

      case 'fish':
        return _AllergenData(
          label: context.l10n.allergenFish,
          emoji: '🐟',
        );

      case 'shellfish':
      case 'crustaceans':
        return _AllergenData(
          label: context.l10n.allergenShellfish,
          emoji: '🦐',
        );

      case 'sesame':
        return _AllergenData(
          label: context.l10n.allergenSesame,
          emoji: '🌱',
        );

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