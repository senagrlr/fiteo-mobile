import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/common/widgets/system_navigation_bar.dart';

import 'package:fiteo_myapp/features/ai_coach/data/ai_chat_repository.dart';
import 'package:fiteo_myapp/features/ai_coach/data/cook_recipe_result.dart';
import 'package:fiteo_myapp/features/ai_coach/data/cook_recipe_service.dart';

import 'package:fiteo_myapp/features/ai_coach/presentation/widgets/cook_mode/cook_loading_view.dart';
import 'package:fiteo_myapp/features/ai_coach/presentation/widgets/cook_mode/cook_message_input.dart';
import 'package:fiteo_myapp/features/ai_coach/presentation/widgets/cook_mode/cook_dietary_requirements_dialog.dart';
import 'package:fiteo_myapp/features/ai_coach/presentation/widgets/cook_mode/cook_recipe_dialog.dart';
import 'package:fiteo_myapp/features/ai_coach/presentation/widgets/cook_mode/cook_welcome_view.dart';

import 'package:fiteo_myapp/features/ai_coach/presentation/widgets/shared/ad_reward_banner.dart';
import 'package:fiteo_myapp/features/ai_coach/presentation/widgets/shared/ai_mode_switch.dart';

import 'package:fiteo_myapp/features/meals/data/meal_repository.dart';
import 'package:fiteo_myapp/features/profile/data/saved_recipe_repository.dart';
import 'package:fiteo_myapp/features/ai_coach/data/ai_usage_limits.dart';
import 'package:fiteo_myapp/features/ai_coach/data/ai_usage_repository.dart';
import 'package:fiteo_myapp/features/ai_coach/data/ai_usage_state.dart';
import 'package:fiteo_myapp/features/membership/data/membership_repository.dart';

class CookAiScreen extends StatefulWidget {
  final VoidCallback onSwitchToCoach;

  const CookAiScreen({
    super.key,
    required this.onSwitchToCoach,
  });

  @override
  State<CookAiScreen> createState() =>
      _CookAiScreenState();
}

class _CookAiScreenState extends State<CookAiScreen> {
  final TextEditingController _ingredientController =
  TextEditingController();

  final AiChatRepository _chatRepository =
  AiChatRepository();

  final CookRecipeService _recipeService =
  CookRecipeService();

  final MealRepository _mealRepository =
  MealRepository();

  final SavedRecipeRepository _savedRecipeRepository =
  SavedRecipeRepository();

  final MembershipRepository _membershipRepository =
  MembershipRepository();

  final AiUsageRepository _usageRepository =
  AiUsageRepository();

  bool _isPremium = false;

  bool isGenerating = false;

  CookRecipeResult? generatedRecipeResult;

  AiUsageState _recipeUsage =
  const AiUsageState.empty();

  String? savedRecipeId;

  bool get _hasReachedDailyRecipeLimit =>
      !_isPremium &&
          _recipeUsage.hasReachedLimit(
            baseLimit: AiUsageLimits.freeRecipes,
          );

  @override
  void initState() {
    super.initState();
    _loadInitialState();
  }

  Future<void> _loadInitialState() async {
    final results = await Future.wait([
      _usageRepository.getTodayRecipeUsage(),
      _membershipRepository.isPremium(),
    ]);

    if (!mounted) {
      return;
    }

    setState(() {
      _recipeUsage = results[0] as AiUsageState;
      _isPremium = results[1] as bool;
    });
  }

  @override
  void dispose() {
    _ingredientController.dispose();
    super.dispose();
  }

  // ============================================================
  // GENERATE RECIPE
  // ============================================================

  Future<void> _sendIngredients() async {
    final text =
    _ingredientController.text.trim();

    if (text.isEmpty || isGenerating) {
      return;
    }

    if (_hasReachedDailyRecipeLimit) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.dailyRecipeLimitReached,
          ),
        ),
      );

      return;
    }

    FocusScope.of(context).unfocus();

    final preferences =
    await _chatRepository
        .getRecipePreferences();

    if (!mounted) {
      return;
    }

    final recipePreferences =
    Map<String, dynamic>.from(
      preferences,
    );

    final hasDietaryRequirements =
    preferences.containsKey(
      'dietaryRequirements',
    );

    if (_isPremium &&
        !hasDietaryRequirements) {
      final selectedRequirements =
      await CookDietaryRequirementsDialog
          .show(
        context,
        initialValues: const [],
        isPremium: true,
      );

      if (selectedRequirements == null ||
          !mounted) {
        return;
      }

      recipePreferences[
      'dietaryRequirements'] =
          selectedRequirements;
    } else if (_isPremium) {
      final rawRequirements =
      preferences[
      'dietaryRequirements'];

      recipePreferences[
      'dietaryRequirements'] =
      rawRequirements is List
          ? rawRequirements
          .map(
            (item) =>
            item.toString(),
      )
          .toList()
          : <String>[];
    } else {
      recipePreferences.remove(
        'dietaryRequirements',
      );
    }

    setState(() {
      isGenerating = true;
      generatedRecipeResult = null;
    });

    _ingredientController.clear();

    final startTime = DateTime.now();

    final recipe =
    await _recipeService.generateRecipe(
      ingredientsText: text,
      preferences: recipePreferences,
    );

    final elapsed =
    DateTime.now().difference(startTime);

    const minimumLoadingDuration =
    Duration(seconds: 5);

    if (elapsed < minimumLoadingDuration) {
      await Future.delayed(
        minimumLoadingDuration - elapsed,
      );
    }

    if (!mounted) {
      return;
    }

    setState(() {
      isGenerating = false;
    });

    if (recipe == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.recipeCouldNotBeCreated,
          ),
        ),
      );

      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      if (!_isPremium) {
        _recipeUsage = AiUsageState(
          usedCount:
          _recipeUsage.usedCount + 1,
          rewardedCredits:
          _recipeUsage.rewardedCredits,
        );
      }

      generatedRecipeResult = recipe;
      savedRecipeId = null;
    });

    await Future.delayed(
      const Duration(milliseconds: 250),
    );

    if (!mounted) {
      return;
    }

    _showRecipeDialog();
  }

  // ============================================================
  // REWARD AD
  // ============================================================

  void _onRewardAdTap() {
    // Şimdilik UI callback.
    //
    // Reklam entegrasyonu yapıldığında:
    //
    // 1. Rewarded reklam açılır.
    // 2. Kullanıcı reklamı tamamlar.
    // 3. Cook AI için +1 kullanım hakkı verilir.
    //
    // UI tarafında banner hazır.
  }

  // ============================================================
  // LOCALIZED MEAL TYPE
  // ============================================================

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

  // ============================================================
  // RECIPE DIALOG
  // ============================================================

  void _showRecipeDialog() {
    final recipe =
        generatedRecipeResult;

    if (recipe == null) {
      return;
    }

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(
        alpha: 0.22,
      ),
      builder: (dialogContext) {
        return CookRecipeDialog(
          recipe: recipe,
          initiallySaved:
          savedRecipeId != null,
          onSavedChanged:
              (isSaved) async {
            if (isSaved) {
              final id =
              await _savedRecipeRepository
                  .saveRecipe(recipe);

              savedRecipeId = id;
            } else {
              final id =
                  savedRecipeId;

              if (id != null) {
                await _savedRecipeRepository
                    .deleteSavedRecipe(id);

                savedRecipeId = null;
              }
            }
          },
          onAddToIntake: () async {
            Navigator.pop(
              dialogContext,
            );

            final mealType =
            await _selectMealType();

            if (mealType == null) {
              return;
            }

            try {
              await _mealRepository.addMeal(
                mealName:
                recipe.recipeName,
                amount:
                1,
                unit:
                'Serving',
                mealType:
                mealType,
                estimatedCalories:
                recipe.caloriesPerServing,
                protein:
                recipe.proteinPerServing,
                fats:
                recipe.fatPerServing,
                carbs:
                recipe.carbsPerServing,
                nutritionSource:
                'ai_recipe',
                isEstimated:
                true,
              );

              if (!mounted) {
                return;
              }

              final localizedMeal =
              _localizedMealType(
                context,
                mealType,
              );

              ScaffoldMessenger.of(context)
                  .showSnackBar(
                SnackBar(
                  content: Text(
                    context.l10n.recipeAddedToMeal(
                      recipe.recipeName,
                      localizedMeal,
                    ),
                  ),
                ),
              );
            } catch (_) {
              if (!mounted) {
                return;
              }

              ScaffoldMessenger.of(context)
                  .showSnackBar(
                SnackBar(
                  content: Text(
                    context.l10n
                        .couldNotAddRecipeToMeals,
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }

  // ============================================================
  // SELECT MEAL TYPE
  // ============================================================

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
            mainAxisSize:
            MainAxisSize.min,
            children:
            mealTypes.map(
                  (mealType) {
                return ListTile(
                  title: Text(
                    _localizedMealType(
                      context,
                      mealType,
                    ),
                    style:
                    AppTextStyles.bodyMedium.copyWith(
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(
                      bottomSheetContext,
                      mealType,
                    );
                  },
                );
              },
            ).toList(),
          ),
        );
      },
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final remainingRecipeRequests =
    _recipeUsage.remaining(
      baseLimit:
      AiUsageLimits.freeRecipes,
    );

    return SystemNavigationBar(
      color: Colors.white,
      child: Scaffold(
        backgroundColor:
        Colors.white,
        body: Stack(
          children: [
            SafeArea(
              child: Stack(
                children: [
                  // =================================================
                  // MODE SWITCH
                  // =================================================

                  Positioned(
                    top: 22,
                    right: 28,
                    child:
                    AiModeSwitch(
                      isCookMode:
                      true,
                      onChanged:
                          (_) {
                        widget
                            .onSwitchToCoach();
                      },
                    ),
                  ),

                  // =================================================
                  // MAIN CONTENT
                  // =================================================

                  Column(
                    children: [
                      const Spacer(
                        flex: 3,
                      ),

                      const CookWelcomeView(),

                      const SizedBox(
                        height: 18,
                      ),

                      if (!_isPremium) ...[
                        Text(
                          remainingRecipeRequests > 0
                              ? context.l10n
                              .recipeRequestsLeftToday(
                            remainingRecipeRequests,
                          )
                              : context.l10n
                              .dailyRecipeLimitReached,
                          style:
                          AppTextStyles.bodySmall.copyWith(
                            color: AppColors
                                .homeSecondaryValue,
                            fontSize: 12,
                            fontWeight:
                            FontWeight.w500,
                          ),
                        ),

                        const SizedBox(
                          height: 12,
                        ),
                      ],

                      CookMessageInput(
                        controller:
                        _ingredientController,
                        onSend:
                        _sendIngredients,
                        horizontalPadding:
                        28,
                        bottomPadding:
                        0,
                      ),

                      const Spacer(
                        flex: 3,
                      ),
                    ],
                  ),

                  // =================================================
                  // REWARD AD
                  // =================================================

                  if (_hasReachedDailyRecipeLimit)
                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: 22,
                      child: Center(
                        child:
                        AdRewardBanner(
                          text:
                          context
                              .l10n
                              .watchAdEarnOneUse,
                          onTap:
                          _onRewardAdTap,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // =====================================================
            // LOADING
            // =====================================================

            AnimatedSwitcher(
              duration:
              const Duration(
                milliseconds: 350,
              ),
              switchInCurve:
              Curves.easeOut,
              switchOutCurve:
              Curves.easeIn,
              child: isGenerating
                  ? const CookLoadingView(
                key:
                ValueKey(
                  'cook-loading',
                ),
              )
                  : const SizedBox.shrink(
                key:
                ValueKey(
                  'cook-empty',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}