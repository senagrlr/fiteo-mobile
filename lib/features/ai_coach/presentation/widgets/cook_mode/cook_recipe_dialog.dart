import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/features/ai_coach/data/cook_recipe_result.dart';
import 'package:fiteo_myapp/features/ai_coach/presentation/widgets/cook_mode/recipe_allergen_chips.dart';

class CookRecipeDialog extends StatefulWidget {
  final CookRecipeResult recipe;
  final Future<void> Function() onAddToIntake;

  final Future<void> Function(bool isSaved)? onSavedChanged;
  final bool initiallySaved;

  const CookRecipeDialog({
    super.key,
    required this.recipe,
    required this.onAddToIntake,
    this.onSavedChanged,
    this.initiallySaved = false,
  });

  @override
  State<CookRecipeDialog> createState() {
    return _CookRecipeDialogState();
  }
}

class _CookRecipeDialogState extends State<CookRecipeDialog>
    with SingleTickerProviderStateMixin {
  late bool isSaved;
  bool isSaving = false;
  bool isAddingToIntake = false;

  late final AnimationController _heartController;
  late final Animation<double> _heartScale;

  @override
  void initState() {
    super.initState();

    isSaved = widget.initiallySaved;

    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );

    _heartScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1,
          end: 1.35,
        ).chain(
          CurveTween(curve: Curves.easeOut),
        ),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.35,
          end: 0.92,
        ).chain(
          CurveTween(curve: Curves.easeInOut),
        ),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.92,
          end: 1,
        ).chain(
          CurveTween(curve: Curves.easeOutBack),
        ),
        weight: 25,
      ),
    ]).animate(_heartController);
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  Future<void> _toggleSaved() async {
    if (isSaving) return;

    final previousValue = isSaved;
    final newValue = !isSaved;

    setState(() {
      isSaved = newValue;
      isSaving = true;
    });

    _heartController.forward(from: 0);

    try {
      await widget.onSavedChanged?.call(newValue);
    } catch (_) {
      if (!mounted) return;

      setState(() {
        isSaved = previousValue;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Recipe could not be saved.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  Future<void> _addToIntake() async {
    if (isAddingToIntake) return;

    setState(() {
      isAddingToIntake = true;
    });

    try {
      await widget.onAddToIntake();
    } finally {
      if (mounted) {
        setState(() {
          isAddingToIntake = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 28,
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.86,
        ),
        padding: const EdgeInsets.fromLTRB(
          22,
          20,
          22,
          18,
        ),
        decoration: BoxDecoration(
          color: AppColors.onboardingBackground,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                AnimatedBuilder(
                  animation: _heartScale,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _heartScale.value,
                      child: child,
                    );
                  },
                  child: IconButton(
                    onPressed: isSaving ? null : _toggleSaved,
                    tooltip: isSaved
                        ? 'Remove from saved'
                        : 'Save recipe',
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      child: Icon(
                        isSaved
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        key: ValueKey(isSaved),
                        color: AppColors.homeBrown,
                        size: 26,
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.homeBrown,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.recipe.recipeName,
                      style: const TextStyle(
                        color: AppColors.homeBrown,
                        fontSize: 24,
                        height: 1.2,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    if (widget.recipe.allergens.isNotEmpty) ...[
                      const SizedBox(height: 20),

                      RecipeAllergenChips(
                        allergens: widget.recipe.allergens,
                      ),
                    ],

                    const SizedBox(height: 24),

                    const _SectionTitle(
                      title: 'Ingredients',
                    ),

                    const SizedBox(height: 12),

                    ...widget.recipe.ingredients.map(
                          (ingredient) {
                        return _IngredientRow(
                          ingredient: ingredient,
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    const _SectionTitle(
                      title: 'Instructions',
                    ),

                    const SizedBox(height: 12),

                    ...List.generate(
                      widget.recipe.instructions.length,
                          (index) {
                        return _InstructionRow(
                          number: index + 1,
                          instruction:
                          widget.recipe.instructions[index],
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    const _SectionTitle(
                      title: 'Nutrition',
                    ),

                    const SizedBox(height: 12),

                    _NutritionSummary(
                      servings: widget.recipe.servings,
                      totalCalories:
                      widget.recipe.totalCalories,
                      caloriesPerServing:
                      widget.recipe.caloriesPerServing,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed:
                isAddingToIntake ? null : _addToIntake,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.homeBrown,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                  AppColors.homeBrown.withValues(
                    alpha: 0.55,
                  ),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: isAddingToIntake
                    ? const SizedBox(
                  width: 21,
                  height: 21,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
                    : const Text(
                  'Add to intake',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.homeBrown,
        fontSize: 17,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  final CookRecipeIngredient ingredient;

  const _IngredientRow({
    required this.ingredient,
  });

  @override
  Widget build(BuildContext context) {
    final amount = ingredient.amount.trim();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(
              top: 7,
              right: 10,
            ),
            decoration: const BoxDecoration(
              color: AppColors.authButtonGreen,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              amount.isEmpty
                  ? ingredient.name
                  : '$amount ${ingredient.name}',
              style: const TextStyle(
                color: AppColors.homeBrown,
                fontSize: 14,
                height: 1.35,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${ingredient.calories} kcal',
            style: TextStyle(
              color: AppColors.homeBrown.withValues(
                alpha: 0.65,
              ),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _InstructionRow extends StatelessWidget {
  final int number;
  final String instruction;

  const _InstructionRow({
    required this.number,
    required this.instruction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 25,
            height: 25,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.authButtonGreen,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$number',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              instruction,
              style: const TextStyle(
                color: AppColors.homeBrown,
                fontSize: 14,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NutritionSummary extends StatelessWidget {
  final int servings;
  final int totalCalories;
  final int caloriesPerServing;

  const _NutritionSummary({
    required this.servings,
    required this.totalCalories,
    required this.caloriesPerServing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _NutritionRow(
            label: 'Servings',
            value: '$servings',
          ),
          _NutritionRow(
            label: 'Total calories',
            value: '$totalCalories kcal',
          ),
          _NutritionRow(
            label: 'Per serving',
            value: '$caloriesPerServing kcal',
            showDivider: false,
          ),
        ],
      ),
    );
  }
}

class _NutritionRow extends StatelessWidget {
  final String label;
  final String value;
  final bool showDivider;

  const _NutritionRow({
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.homeBrown,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.homeBrown,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Divider(
              height: 1,
              color: AppColors.homeBrown.withValues(
                alpha: 0.08,
              ),
            ),
          ),
      ],
    );
  }
}