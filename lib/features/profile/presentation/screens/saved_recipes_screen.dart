import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/common/widgets/system_navigation_bar.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/saved_recipe_card.dart';
import 'package:fiteo_myapp/features/profile/data/saved_recipe_repository.dart';
import 'package:fiteo_myapp/features/ai_coach/data/cook_recipe_result.dart';
import 'package:fiteo_myapp/features/ai_coach/presentation/widgets/cook_mode/cook_recipe_dialog.dart';
import 'package:fiteo_myapp/features/meals/data/meal_repository.dart';

class SavedRecipesScreen extends StatefulWidget {
  const SavedRecipesScreen({super.key});

  @override
  State<SavedRecipesScreen> createState() =>
      _SavedRecipesScreenState();
}

class _SavedRecipesScreenState
    extends State<SavedRecipesScreen> {
  final SavedRecipeRepository _savedRecipeRepository =
  SavedRecipeRepository();

  final MealRepository _mealRepository =
  MealRepository();

  List<Map<String, dynamic>> savedRecipes = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedRecipes();
  }

  Future<void> _loadSavedRecipes() async {
    try {
      final snapshot =
      await _savedRecipeRepository.getSavedRecipes();

      final recipes = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();

      if (!mounted) return;

      setState(() {
        savedRecipes = recipes;
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  String _localizedMealType(
      BuildContext context,
      String mealType,
      ) {
    switch (mealType) {
      case 'Breakfast':
        return context.l10n.breakfast;

      case 'Lunch':
        return context.l10n.lunch;

      case 'Dinner':
        return context.l10n.dinner;

      case 'Snacks':
        return context.l10n.snack;

      default:
        return mealType;
    }
  }

  Future<String?> _selectMealType() async {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (bottomSheetContext) {
        const mealTypes = [
          'Breakfast',
          'Lunch',
          'Dinner',
          'Snacks',
        ];

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: mealTypes.map((mealType) {
              return ListTile(
                title: Text(
                  _localizedMealType(
                    context,
                    mealType,
                  ),
                  style:
                  AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.homeBrown,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Navigator.pop(
                    bottomSheetContext,
                    mealType,
                  );
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SystemNavigationBar(
        color: Colors.white,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return SystemNavigationBar(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.homeBrown,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            context.l10n.savedRecipes,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.homeBrown,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
        body: savedRecipes.isEmpty
            ? const _EmptySavedRecipes()
            : GridView.builder(
          padding: const EdgeInsets.fromLTRB(
            24,
            20,
            24,
            40,
          ),
          itemCount: savedRecipes.length,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 22,
            childAspectRatio: 1.35,
          ),
          itemBuilder: (context, index) {
            final recipe =
            savedRecipes[index];

            return SavedRecipeCard(
              recipeName:
              recipe['recipeName']
              as String? ??
                  '',
              calories:
              (recipe['caloriesPerServing']
              as num?)
                  ?.round() ??
                  0,
              onTap: () {
                final savedRecipe =
                CookRecipeResult.fromMap(
                  recipe,
                );

                showDialog(
                  context: context,
                  barrierColor: Colors.black
                      .withValues(
                    alpha: 0.22,
                  ),
                  builder:
                      (dialogContext) {
                    return CookRecipeDialog(
                      recipe: savedRecipe,
                      initiallySaved: true,
                      onSavedChanged:
                          (isSaved) async {
                        if (!isSaved) {
                          final recipeId =
                          recipe['id']
                          as String?;

                          if (recipeId !=
                              null) {
                            await _savedRecipeRepository
                                .deleteSavedRecipe(
                              recipeId,
                            );

                            await _loadSavedRecipes();
                          }
                        }
                      },
                      onAddToIntake:
                          () async {
                        Navigator.pop(
                          dialogContext,
                        );

                        final mealType =
                        await _selectMealType();

                        if (mealType ==
                            null) {
                          return;
                        }

                        await _mealRepository
                            .addMeal(
                          mealName:
                          savedRecipe
                              .recipeName,
                          amount: 1,
                          unit: 'Serving',
                          mealType:
                          mealType,
                          estimatedCalories:
                          savedRecipe
                              .caloriesPerServing,
                          protein:
                          savedRecipe
                              .proteinPerServing
                              .round(),
                          fats:
                          savedRecipe
                              .fatPerServing
                              .round(),
                          carbs:
                          savedRecipe
                              .carbsPerServing
                              .round(),
                          nutritionSource:
                          'ai_recipe',
                          isEstimated:
                          true,
                        );

                        if (!mounted) {
                          return;
                        }

                        final localizedMealType =
                        _localizedMealType(
                          context,
                          mealType,
                        );

                        ScaffoldMessenger.of(
                          this.context,
                        ).showSnackBar(
                          SnackBar(
                            content: Text(
                              context.l10n
                                  .recipeAddedToMeal(
                                savedRecipe
                                    .recipeName,
                                localizedMealType,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _EmptySavedRecipes extends StatelessWidget {
  const _EmptySavedRecipes();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.translate(
        offset: const Offset(0, -30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
              ),
              child: SizedBox(
                width: 320,
                height: 320,
                child: Lottie.asset(
                  'assets/animations/empty.json',
                  repeat: true,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 2),

            Text(
              context.l10n.noSavedRecipesYet,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color:
                AppColors.homeSecondaryValue,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}