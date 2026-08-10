import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
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
  final SavedRecipeRepository _savedRecipeRepository = SavedRecipeRepository();
  final MealRepository _mealRepository = MealRepository();

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

  Future<String?> _selectMealType() async {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (context) {
        final mealTypes = [
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
                  mealType,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context, mealType);
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
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
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
        title: const Text(
          'Saved Recipes',
          style: TextStyle(
            color: AppColors.homeBrown,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: savedRecipes.isEmpty
          ? const _EmptySavedRecipes()
          : GridView.builder(
        padding: const EdgeInsets.fromLTRB(
          32,
          20,
          32,
          40,
        ),
        itemCount: savedRecipes.length,
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 18,
          mainAxisSpacing: 28,
          childAspectRatio: 1.55,
        ),
        itemBuilder: (context, index) {
          final recipe = savedRecipes[index];

          return SavedRecipeCard(
            recipeName:
            recipe['recipeName'] as String? ?? '',
            calories:
            (recipe['caloriesPerServing'] as num?)
                ?.round() ??
                0,
            onTap: () {
              final savedRecipe =
              CookRecipeResult.fromMap(recipe);

              showDialog(
                context: context,
                barrierColor: Colors.black.withValues(
                  alpha: 0.22,
                ),
                builder: (context) {
                  return CookRecipeDialog(
                    recipe: savedRecipe,
                    initiallySaved: true,
                    onSavedChanged: (isSaved) async {
                      if (!isSaved) {
                        final recipeId =
                        recipe['id'] as String?;

                        if (recipeId != null) {
                          await _savedRecipeRepository
                              .deleteSavedRecipe(recipeId);

                          await _loadSavedRecipes();
                        }
                      }
                    },
                    onAddToIntake: () async {
                      Navigator.pop(context);

                      final mealType = await _selectMealType();

                      if (mealType == null) return;

                      await _mealRepository.addMeal(
                        mealName: savedRecipe.recipeName,
                        amount: 1,
                        unit: 'Serving',
                        mealType: mealType,
                        estimatedCalories: savedRecipe.caloriesPerServing,
                        protein: savedRecipe.proteinPerServing.round(),
                        fats: savedRecipe.fatPerServing.round(),
                        carbs: savedRecipe.carbsPerServing.round(),
                        nutritionSource: 'ai_recipe',
                        isEstimated: true,
                      );

                      if (!mounted) return;

                      ScaffoldMessenger.of(this.context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${savedRecipe.recipeName} added to $mealType.',
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
              padding: const EdgeInsets.only(left: 20),
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

            const Text(
              'No saved recipes yet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFB5B5B5),
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