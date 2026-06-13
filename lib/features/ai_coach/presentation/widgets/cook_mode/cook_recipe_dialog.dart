import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/features/ai_coach/data/cook_recipe_result.dart';

class CookRecipeDialog extends StatelessWidget {
  final CookRecipeResult recipe;
  final Future<void> Function() onAddToIntake;

  const CookRecipeDialog({
    super.key,
    required this.recipe,
    required this.onAddToIntake,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 26),
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 560),
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
        decoration: BoxDecoration(
          color: AppColors.onboardingBackground,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Your Recipe',
                    style: TextStyle(
                      color: AppColors.homeBrown,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),

                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.homeBrown,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Flexible(
              child: SingleChildScrollView(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    recipe.toDisplayText(),
                    style: const TextStyle(
                      color: AppColors.homeBrown,
                      fontSize: 15,
                      height: 1.45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 22),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () async {
                  await onAddToIntake();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.homeBrown,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
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