import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';

import 'package:fiteo_myapp/features/membership/presentation/premium_navigation.dart';

class CookNutritionPreferenceDialog {
  static const List<String> options = [
    'No Restrictions',
    'Balanced Diet',
    'High Protein',
    'Mediterranean',
    'Vegetarian',
    'Vegan',
    'Keto',
    'Gluten Free',
  ];

  static Future<String?> show(
      BuildContext context, {
        String? initialValue,
        required bool isPremium,
      }) {
    String? selectedValue;
    String? lockedOption;

    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(
        alpha: 0.22,
      ),
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
              context,
              setDialogState,
              ) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 26,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(
                  24,
                  28,
                  24,
                  22,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfacePrimary,
                  borderRadius:
                  BorderRadius.circular(28),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.l10n
                          .chooseRecipeNutritionPreference,
                      textAlign: TextAlign.center,
                      style:
                      AppTextStyles.titleMedium.copyWith(
                        color: AppColors.homeBrown,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 22),

                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 10,
                      children: options.map(
                            (option) {
                          final isSelected =
                              selectedValue == option;

                          final showLock =
                              !isPremium &&
                                  lockedOption == option;

                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                if (!isPremium) {
                                  setDialogState(() {
                                    lockedOption = option;
                                  });

                                  return;
                                }

                                setDialogState(() {
                                  selectedValue = option;
                                  lockedOption = null;
                                });
                              },
                              borderRadius:
                              BorderRadius.circular(
                                22,
                              ),
                              child: AnimatedContainer(
                                duration: const Duration(
                                  milliseconds: 160,
                                ),
                                padding:
                                const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors
                                      .brandPrimary
                                      .withValues(
                                    alpha: 0.16,
                                  )
                                      : AppColors.surfaceSoft,
                                  borderRadius:
                                  BorderRadius.circular(
                                    22,
                                  ),
                                  border: Border.all(
                                    color: showLock
                                        ? AppColors.homeBrown
                                        : isSelected
                                        ? AppColors
                                        .brandPrimary
                                        : AppColors
                                        .homeBrown
                                        .withValues(
                                      alpha: 0.08,
                                    ),
                                    width:
                                    showLock || isSelected
                                        ? 1.5
                                        : 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize:
                                  MainAxisSize.min,
                                  children: [
                                    if (showLock) ...[
                                      const Icon(
                                        Icons
                                            .lock_outline_rounded,
                                        color:
                                        AppColors.homeBrown,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 5),
                                    ] else if (isSelected) ...[
                                      const Icon(
                                        Icons.check_rounded,
                                        color: AppColors
                                            .brandPrimary,
                                        size: 17,
                                      ),
                                      const SizedBox(width: 5),
                                    ],

                                    Text(
                                      _label(
                                        context,
                                        option,
                                      ),
                                      style: AppTextStyles
                                          .labelMedium
                                          .copyWith(
                                        color: showLock
                                            ? AppColors.homeBrown
                                            : isSelected
                                            ? AppColors
                                            .homeBrown
                                            : AppColors
                                            .homeSecondaryValue,
                                        fontSize: 13,
                                        fontWeight:
                                        showLock ||
                                            isSelected
                                            ? FontWeight
                                            .w700
                                            : FontWeight
                                            .w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      isPremium
                          ? context.l10n
                          .recipePreferenceChangeHint
                          : context.l10n
                          .recipeCustomizationPremiumHint,
                      textAlign: TextAlign.center,
                      style:
                      AppTextStyles.bodySmall.copyWith(
                        color:
                        AppColors.homeSecondaryValue,
                        fontSize: 11,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 20),

                    if (!isPremium) ...[
                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: ElevatedButton(
                          onPressed: () {
                            PremiumNavigation.openPaywall(
                              context,
                            );
                          },
                          style:
                          ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                            AppColors.brandPrimary,
                            foregroundColor:
                            AppColors.onPrimary,
                            shape:
                            const StadiumBorder(),
                          ),
                          child: Text(
                            context.l10n.goPremium,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight:
                              FontWeight.w800,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                    ],

                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: OutlinedButton(
                        onPressed: () {
                          final fallbackValue =
                          options.contains(initialValue)
                              ? initialValue!
                              : 'No Restrictions';

                          Navigator.pop(
                            dialogContext,
                            selectedValue ??
                                fallbackValue,
                          );
                        },
                        style:
                        OutlinedButton.styleFrom(
                          foregroundColor:
                          AppColors.homeBrown,
                          side: BorderSide(
                            color: AppColors.homeBrown
                                .withValues(
                              alpha: 0.22,
                            ),
                          ),
                          shape:
                          const StadiumBorder(),
                        ),
                        child: Text(
                          context.l10n.continueToRecipe,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight:
                            FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  static String _label(
      BuildContext context,
      String value,
      ) {
    switch (value) {
      case 'No Restrictions':
        return context
            .l10n.nutritionNoRestrictions;

      case 'High Protein':
        return context
            .l10n.nutritionHighProtein;

      case 'Balanced Diet':
        return context
            .l10n.nutritionBalancedDiet;

      case 'Vegetarian':
        return context
            .l10n.nutritionVegetarian;

      case 'Vegan':
        return context.l10n.nutritionVegan;

      case 'Keto':
        return context.l10n.nutritionKeto;

      case 'Gluten Free':
        return context
            .l10n.nutritionGlutenFree;

      case 'Mediterranean':
        return context.l10n.nutritionMediterranean;

      default:
        return value;
    }
  }
}