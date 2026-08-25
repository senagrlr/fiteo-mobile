import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/features/meals/data/meal_calorie_service.dart';
import 'package:fiteo_myapp/features/meals/domain/models/barcode_food_data.dart';
import 'package:fiteo_myapp/features/meals/presentation/screens/meals_screen.dart';
import 'package:fiteo_myapp/core/constants/nutrition_market_resolver.dart';
import 'package:fiteo_myapp/features/meals/data/serving_normalizer.dart';

import 'package:fiteo_myapp/features/meals/presentation/widgets/barcode_add_button.dart';

class AddFoodForm extends StatefulWidget {
  final ValueChanged<FoodItem> onAddFood;

  const AddFoodForm({
    super.key,
    required this.onAddFood,
  });

  @override
  State<AddFoodForm> createState() =>
      _AddFoodFormState();
}

class _AddFoodFormState extends State<AddFoodForm> {
  final foodController = TextEditingController();
  final amountController = TextEditingController();
  MealCalorieService? _mealCalorieService;
  String? _currentNutritionLanguageCode;

  List<FoodServingOption> servingOptions = const [
    FoodServingOption.grams(),
  ];

  String selectedServingKey = 'grams';

  Timer? _foodLookupDebounce;
  int _foodLookupRequestId = 0;

  MealCalorieResult? _lookupResult;
  MealCalorieResult? lastCalorieResult;

  int estimatedCalories = 0;
  double estimatedProtein = 0;
  double estimatedFats = 0;
  double estimatedCarbs = 0;

  bool isEstimating = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final languageCode =
        Localizations.localeOf(context).languageCode;

    if (_currentNutritionLanguageCode == languageCode) {
      return;
    }

    final market =
    NutritionMarketResolver.fromLanguageCode(
      languageCode,
    );

    _mealCalorieService =
        MealCalorieService(
          market: market,
        );

    _currentNutritionLanguageCode = languageCode;
  }

  void _loadFoodOptions() {
    _foodLookupDebounce?.cancel();

    final requestId = ++_foodLookupRequestId;
    final foodName = foodController.text.trim();

    _lookupResult = null;
    lastCalorieResult = null;

    if (foodName.isEmpty) {
      _resetValues();
      return;
    }

    setState(() {
      servingOptions = const [
        FoodServingOption.grams(),
      ];
      selectedServingKey = 'grams';

      estimatedCalories = 0;
      estimatedProtein = 0.0;
      estimatedFats = 0.0;
      estimatedCarbs = 0.0;
    });

    _foodLookupDebounce = Timer(
      const Duration(milliseconds: 500),
          () async {
        try {
          final result = await _mealCalorieService!.lookupFood(
            foodName: foodName,
          );

          print(
            'LOOKUP RESULT: ${result?.foodName} | '
                'SOURCE: ${result?.source} | '
                'SERVINGS: ${result?.servings.map((e) => e.description).toList()}',
          );

          if (!mounted || requestId != _foodLookupRequestId) return;

          final newServingOptions = ServingNormalizer.buildOptions(
            result?.servings ?? const [],
            foodName: result?.foodName,
            hasPer100gServing: result?.hasPer100gServing ?? false,
          );

          print(
            'SERVING OPTIONS: ${newServingOptions.map((e) => e.label).toList()}',
          );

          setState(() {
            _lookupResult = result;
            servingOptions = newServingOptions;

            if (servingOptions.isNotEmpty &&
                !servingOptions.any(
                      (option) => option.key == selectedServingKey,
                )) {
              selectedServingKey = servingOptions.first.key;
            }
          });

          _estimateCalories();
        } catch (e) {
          print('FOOD LOOKUP ERROR: $e');
          if (!mounted || requestId != _foodLookupRequestId) return;

          setState(() {
            _lookupResult = null;
            servingOptions = const [
              FoodServingOption.grams(),
            ];
            selectedServingKey = 'grams';
          });
        }
      },
    );
  }

  void _estimateCalories() {
    final lookup = _lookupResult;
    final amount = int.tryParse(amountController.text.trim()) ?? 0;

    if (lookup == null || amount <= 0) {
      if (!mounted) return;

      setState(() {
        estimatedCalories = 0;
        estimatedProtein = 0;
        estimatedFats = 0;
        estimatedCarbs = 0;
        isEstimating = false;
        lastCalorieResult = null;
      });

      return;
    }

    final selectedOption = servingOptions.firstWhere(
          (option) => option.key == selectedServingKey,
      orElse: () => const FoodServingOption.grams(),
    );

    MealCalorieResult? result;

    if (selectedOption.type == ServingType.grams) {
      result = _mealCalorieService!.calculateLookupForGrams(
        lookup: lookup,
        gram: amount,
      );
    } else if (selectedOption.servingId != null) {
      result = _mealCalorieService!.calculateLookupForServing(
        lookup: lookup,
        amount: amount.toDouble(),
        servingId: selectedOption.servingId!,
        isPiece: selectedOption.type == ServingType.piece,
      );
    }

    if (!mounted) return;

    print(
      'NUTRITION SOURCE: ${result?.source} | '
          'ESTIMATED: ${result?.isEstimated} | '
          'CAL: ${result?.estimatedCalories} | '
          'P: ${result?.protein} | '
          'F: ${result?.fat} | '
          'C: ${result?.carbs}',
    );

    setState(() {
      lastCalorieResult = result;
      estimatedCalories = result?.estimatedCalories ?? 0;
      estimatedProtein = result?.protein ?? 0;
      estimatedFats = result?.fat ?? 0;
      estimatedCarbs = result?.carbs ?? 0;
      isEstimating = false;
    });
  }

  void _resetValues() {
    if (!mounted) return;

    setState(() {
      _lookupResult = null;

      servingOptions = const [
        FoodServingOption.grams(),
      ];

      selectedServingKey = 'grams';

      estimatedCalories = 0;
      estimatedProtein = 0.0;
      estimatedFats = 0.0;
      estimatedCarbs = 0.0;
      isEstimating = false;
      lastCalorieResult = null;
    });
  }

  // ============================================================
  // MANUEL YEMEK EKLEME
  // ============================================================

  Future<void> _addFood() async {
    final foodName =
    foodController.text.trim();

    final amount =
    amountController.text.trim();

    if (foodName.isEmpty || amount.isEmpty || lastCalorieResult == null) {
      return;
    }

    final selectedOption = servingOptions.firstWhere(
          (option) => option.key == selectedServingKey,
      orElse: () => const FoodServingOption.grams(),
    );

    widget.onAddFood(
      FoodItem(
        name: foodName,
        amount: amount,
        unit: ServingNormalizer.labelForType(selectedOption.type),
        calories: estimatedCalories,
        protein: estimatedProtein,
        fats: estimatedFats,
        carbs: estimatedCarbs,
        nutritionSource:
        lastCalorieResult!.source,
        isEstimated:
        lastCalorieResult!.isEstimated,
      ),
    );

    await _mealCalorieService!.confirmFoodAlias(
      query: foodName,
      result: lastCalorieResult!,
    );

    foodController.clear();
    amountController.clear();

    _resetValues();
  }

  // ============================================================
  // BARKODDAN YEMEK EKLEME
  // ============================================================

  void _addBarcodeFood(
      BarcodeFoodData data,
      ) {
    widget.onAddFood(
      FoodItem(
        name: data.name,
        amount: data.amount,
        unit: data.unit,
        calories: data.calories,
        protein: data.protein,
        fats: data.fats,
        carbs: data.carbs,
        nutritionSource:
        data.nutritionSource,
        isEstimated:
        data.isEstimated,
      ),
    );
  }

  @override
  void dispose() {
    _foodLookupDebounce?.cancel();
    foodController.dispose();
    amountController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ======================================================
        // MANUEL YEMEK EKLE
        // ======================================================

        Center(
          child: GestureDetector(
            onTap: _addFood,
            child: Container(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 26,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color:
                AppColors.calendarCompleted,
                borderRadius:
                BorderRadius.circular(22),
              ),
              child: Text(
                context.l10n.addFood,
                style:
                AppTextStyles.titleMedium
                    .copyWith(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight:
                  FontWeight.w800,
                ),
              ),
            ),
          ),
        ),

        // ======================================================
        // BARKODLA EKLE
        // ======================================================

        const SizedBox(height: 12),

        BarcodeAddButton(
          onFoodFound: _addBarcodeFood,
        ),

        const SizedBox(height: 18),

        // ======================================================
        // YEMEK ADI
        // ======================================================

        _MealInputField(
          controller: foodController,
          hintText: context.l10n.foodName,
          onChanged: (_) => _loadFoodOptions(),
        ),

        const SizedBox(height: 10),

        // ======================================================
        // MİKTAR + BİRİM
        // ======================================================

        _MealAmountField(
          controller: amountController,
          selectedServingKey: selectedServingKey,
          options: servingOptions,
          amountHint: context.l10n.amount,
          onServingChanged: (value) {
            setState(() {
              selectedServingKey = value;
            });

            _estimateCalories();
          },
          onChanged: (_) =>
              _estimateCalories(),
        ),

        const SizedBox(height: 18),

        Text(
          context
              .l10n
              .calorieEstimateDisclaimer,
          textAlign: TextAlign.center,
          style:
          AppTextStyles.labelSmall
              .copyWith(
            color:
            AppColors.waterCardInactiveText,
            fontSize: 10,
            height: 1.3,
            fontWeight: FontWeight.w400,
          ),
        ),

        const SizedBox(height: 18),

        // ======================================================
        // MAKROLAR
        // ======================================================

        Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            _MacroChip(
              title:
              context.l10n.protein,
              value: estimatedProtein,
              isLoading: isEstimating,
              showValue: lastCalorieResult != null,
            ),

            const SizedBox(width: 8),

            _MacroChip(
              title:
              context.l10n.fats,
              value: estimatedFats,
              isLoading: isEstimating,
              showValue: lastCalorieResult != null,
            ),

            const SizedBox(width: 8),

            _MacroChip(
              title:
              context.l10n.carbs,
              value: estimatedCarbs,
              isLoading: isEstimating,
              showValue: lastCalorieResult != null,
            ),
          ],
        ),

        const SizedBox(height: 8),

        _MacroChip(
          title:
          context.l10n.calories,
          value: estimatedCalories,
          isLoading: isEstimating,
          wide: true,
          suffix: 'kcal',
          showValue: lastCalorieResult != null,
        ),
      ],
    );
  }
}

// ============================================================
// MACRO CHIP
// ============================================================

class _MacroChip extends StatelessWidget {
  final String title;
  final num value;
  final bool isLoading;
  final bool wide;
  final String suffix;
  final bool showValue;

  const _MacroChip({
    required this.title,
    required this.value,
    required this.isLoading,
    this.wide = false,
    this.suffix = 'g',
    this.showValue = false,
  });

  @override
  Widget build(BuildContext context) {
    String text = title;

    if (isLoading) {
      text = '...';
    } else if (showValue) {
      if (suffix == 'kcal') {
        text = '${value.round()} $suffix';
      } else {
        final macroValue = value.toDouble();

        final formattedValue = macroValue == 0
            ? '0'
            : macroValue.toStringAsFixed(1);

        text = '$formattedValue $suffix';
      }
    }

    return AnimatedContainer(
      duration:
      const Duration(milliseconds: 220),
      width: wide ? 150 : 70,
      height: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color:
        AppColors.homeCardBackground,
        borderRadius:
        BorderRadius.circular(20),
      ),
      child: AnimatedSwitcher(
        duration:
        const Duration(milliseconds: 180),
        child: Text(
          text,
          key: ValueKey(text),
          style:
          AppTextStyles.bodyMedium
              .copyWith(
            color: AppColors.homeBrown,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// YEMEK ADI FIELD
// ============================================================

class _MealInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>?
  inputFormatters;

  const _MealInputField({
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.onChanged,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      height: 38,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged,
        inputFormatters:
        inputFormatters,
        style:
        AppTextStyles.bodyMedium
            .copyWith(
          color: AppColors.homeBrown,
          fontSize: 13,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle:
          AppTextStyles.bodyMedium
              .copyWith(
            color:
            AppColors.homeSecondaryValue,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor:
          AppColors.homeCardBackground,
          contentPadding:
          const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 8,
          ),
          border: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(22),
            borderSide: BorderSide.none,
          ),
          enabledBorder:
          OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(22),
            borderSide: BorderSide.none,
          ),
          focusedBorder:
          OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(22),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// MİKTAR + BİRİM FIELD
// ============================================================

class _MealAmountField
    extends StatelessWidget {
  final TextEditingController controller;
  final String selectedServingKey;
  final List<FoodServingOption> options;
  final String amountHint;
  final ValueChanged<String> onServingChanged;
  final ValueChanged<String>? onChanged;

  const _MealAmountField({
    required this.controller,
    required this.selectedServingKey,
    required this.options,
    required this.amountHint,
    required this.onServingChanged,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      height: 38,
      decoration: BoxDecoration(
        color: AppColors.homeCardBackground,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: onChanged,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.homeBrown,
                fontSize: 13,
                height: 1,
              ),
              decoration:
              InputDecoration(
                hintText: amountHint,
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.homeSecondaryValue,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  height: 1,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.only(
                  left: 18,
                  right: 8,
                ),
              ),
            ),
          ),
          Container(
            width: 1,
            height: 20,
            color: AppColors.mealFieldDivider,
          ),
          SizedBox(
            width: 94,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedServingKey,
                isExpanded: true,
                borderRadius: BorderRadius.circular(18),
                dropdownColor: AppColors.homeCardBackground,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: AppColors.homeSecondaryValue,
                ),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.homeSecondaryValue,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 7,
                ),
                items: options.map((option) {
                  return DropdownMenuItem<String>(
                    value: option.key,
                    child: Text(
                      option.label,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.homeSecondaryValue,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    onServingChanged(value);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}