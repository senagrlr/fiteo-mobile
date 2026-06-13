import 'package:flutter/material.dart';
import 'package:fiteo_myapp/features/ai_coach/presentation/widgets/cook_mode/cook_welcome_view.dart';
import 'package:fiteo_myapp/features/ai_coach/presentation/widgets/cook_mode/cook_message_input.dart';
import 'package:fiteo_myapp/features/ai_coach/presentation/widgets/cook_mode/cook_loading_view.dart';
import 'package:fiteo_myapp/features/ai_coach/presentation/widgets/cook_mode/cook_recipe_dialog.dart';
import 'package:fiteo_myapp/features/ai_coach/presentation/widgets/shared/ai_mode_switch.dart';
import 'package:fiteo_myapp/features/ai_coach/data/ai_chat_repository.dart';
import 'package:fiteo_myapp/features/ai_coach/data/cook_recipe_result.dart';
import 'package:fiteo_myapp/features/ai_coach/data/cook_recipe_service.dart';
import 'package:fiteo_myapp/features/meals/data/meal_repository.dart';

class CookAiScreen extends StatefulWidget {
  final VoidCallback onSwitchToCoach;

  const CookAiScreen({
    super.key,
    required this.onSwitchToCoach,
  });

  @override
  State<CookAiScreen> createState() => _CookAiScreenState();
}

class _CookAiScreenState extends State<CookAiScreen> {
  final TextEditingController _ingredientController = TextEditingController();
  final AiChatRepository _chatRepository = AiChatRepository();
  final CookRecipeService _recipeService = CookRecipeService();
  final MealRepository _mealRepository = MealRepository();

  bool isGenerating = false;
  CookRecipeResult? generatedRecipeResult;
  int recipeCount = 0;

  static const int dailyRecipeLimit = 2;

  @override
  void initState() {
    super.initState();
    _loadRecipeCount();
  }

  Future<void> _loadRecipeCount() async {
    final count = await _chatRepository.getTodayRecipeCount();

    if (!mounted) return;

    setState(() {
      recipeCount = count;
    });
  }

  @override
  void dispose() {
    _ingredientController.dispose();
    super.dispose();
  }

  Future<void> _sendIngredients() async {
    final text = _ingredientController.text.trim();

    if (text.isEmpty || isGenerating) return;

    if (recipeCount >= dailyRecipeLimit) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Daily recipe limit reached.'),
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      isGenerating = true;
      generatedRecipeResult = null;
    });

    _ingredientController.clear();

    final preferences = await _chatRepository.getRecipePreferences();

    final startTime = DateTime.now();

    final recipe = await _recipeService.generateRecipe(
      ingredientsText: text,
      preferences: preferences,
    );

    final elapsed = DateTime.now().difference(startTime);
    const minimumLoadingDuration = Duration(seconds: 5);

    if (elapsed < minimumLoadingDuration) {
      await Future.delayed(
        minimumLoadingDuration - elapsed,
      );
    }

    if (!mounted) return;

    setState(() {
      isGenerating = false;
    });

    if (recipe == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recipe could not be created. Please try again.'),
        ),
      );
      return;
    }

    await _chatRepository.incrementTodayRecipeCount();

    if (!mounted) return;

    setState(() {
      recipeCount++;
      generatedRecipeResult = recipe;
    });

    await Future.delayed(const Duration(milliseconds: 250));

    if (!mounted) return;

    _showRecipeDialog();
  }

  void _showRecipeDialog() {
    final recipe = generatedRecipeResult;

    if (recipe == null) return;

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.22),
      builder: (context) {
        return CookRecipeDialog(
          recipe: recipe,
          onAddToIntake: () async {
            Navigator.pop(context);

            final mealType = await _selectMealType();

            if (mealType == null) return;

            try {
              await _mealRepository.addMeal(
                mealName: recipe.recipeName,
                gram: 1,
                mealType: mealType,
                estimatedCalories: recipe.caloriesPerServing,
              );

              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${recipe.recipeName} added to $mealType.'),
                ),
              );
            } catch (_) {
              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Could not add recipe to meals.'),
                ),
              );
            }
          },
        );
      },
    );
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
                onTap: () => Navigator.pop(context, mealType),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: 22,
                  right: 28,
                  child: AiModeSwitch(
                    isCookMode: true,
                    onChanged: (_) => widget.onSwitchToCoach(),
                  ),
                ),

                Column(
                  children: [
                    const Spacer(flex: 3),

                    const CookWelcomeView(),

                    const SizedBox(height: 18),

                    Text(
                      '${(dailyRecipeLimit - recipeCount).clamp(0, dailyRecipeLimit)} recipe requests left today',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 12),

                    CookMessageInput(
                      controller: _ingredientController,
                      onSend: _sendIngredients,
                      horizontalPadding: 28,
                      bottomPadding: 0,
                    ),

                    const Spacer(flex: 3),
                  ],
                ),
              ],
            ),
          ),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: isGenerating
                ? const CookLoadingView(
              key: ValueKey('cook-loading'),
            )
                : const SizedBox.shrink(
              key: ValueKey('cook-empty'),
            ),
          ),
        ],
      ),
    );
  }
}