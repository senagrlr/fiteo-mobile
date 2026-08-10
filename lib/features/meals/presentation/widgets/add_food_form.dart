import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/features/meals/data/food_calorie_cache_repository.dart';
import 'package:fiteo_myapp/features/meals/data/meal_calorie_service.dart';
import 'package:fiteo_myapp/features/meals/presentation/screens/meals_screen.dart';
import 'package:fiteo_myapp/features/meals/domain/models/nutrition_food.dart';

class AddFoodForm extends StatefulWidget {
  final ValueChanged<FoodItem> onAddFood;

  const AddFoodForm({
    super.key,
    required this.onAddFood,
  });

  @override
  State<AddFoodForm> createState() => _AddFoodFormState();
}

class _AddFoodFormState extends State<AddFoodForm> {
  final foodController = TextEditingController();
  final amountController = TextEditingController();

  final _mealCalorieService = MealCalorieService();
  final _foodCacheRepository = FoodCalorieCacheRepository();

  final List<String> units = const [
    'Grams',
    'Pieces',
  ];

  String selectedUnit = 'Grams';

  Timer? _debounce;
  int _calorieRequestId = 0;

  MealCalorieResult? lastCalorieResult;

  int estimatedCalories = 0;
  int estimatedProtein = 0;
  int estimatedFats = 0;
  int estimatedCarbs = 0;

  bool isEstimating = false;

  void _estimateCalories() {
    _debounce?.cancel();

    final requestId = ++_calorieRequestId;

    _debounce = Timer(
      const Duration(milliseconds: 700),
          () async {
        final foodName = foodController.text.trim();
        final amount =
            int.tryParse(amountController.text.trim()) ?? 0;

        if (foodName.isEmpty || amount == 0) {
          _resetValues();
          return;
        }

        if (!mounted) return;

        setState(() {
          isEstimating = true;
        });

        try {
          final MealCalorieResult? result;

          if (selectedUnit == 'Grams') {
            result =
            await _mealCalorieService.estimateForGrams(
              foodName: foodName,
              gram: amount,
            );
          } else {
            result =
            await _mealCalorieService.estimateForPieces(
              foodName: foodName,
              pieces: amount.toDouble(),
            );
          }

          if (!mounted ||
              requestId != _calorieRequestId) {
            return;
          }

          setState(() {
            lastCalorieResult = result;

            estimatedCalories =
                result?.estimatedCalories ?? 0;

            estimatedProtein =
                result?.protein.round() ?? 0;

            estimatedFats =
                result?.fat.round() ?? 0;

            estimatedCarbs =
                result?.carbs.round() ?? 0;

            isEstimating = false;
          });
        } catch (_) {
          if (!mounted ||
              requestId != _calorieRequestId) {
            return;
          }

          _resetValues();
        }
      },
    );
  }

  void _resetValues() {
    if (!mounted) return;

    setState(() {
      estimatedCalories = 0;
      estimatedProtein = 0;
      estimatedFats = 0;
      estimatedCarbs = 0;
      isEstimating = false;
      lastCalorieResult = null;
    });
  }

  Future<void> _addFood() async {
    final foodName = foodController.text.trim();
    final amount = amountController.text.trim();

    if (foodName.isEmpty ||
        amount.isEmpty ||
        estimatedCalories == 0 ||
        lastCalorieResult == null) {
      return;
    }

    if (selectedUnit == 'Grams') {
      final amountValue = int.tryParse(amount) ?? 0;

      if (amountValue > 0) {
        final proteinPer100g =
            lastCalorieResult!.protein * 100 / amountValue;

        final fatPer100g =
            lastCalorieResult!.fat * 100 / amountValue;

        final carbsPer100g =
            lastCalorieResult!.carbs * 100 / amountValue;

        final food = NutritionFood(
          id: lastCalorieResult!.normalizedName,
          name: lastCalorieResult!.foodName,
          caloriesPer100g: lastCalorieResult!.caloriesPer100g.toDouble(),
          proteinPer100g: proteinPer100g,
          fatPer100g: fatPer100g,
          carbsPer100g: carbsPer100g,
          servings: const [],
          source: lastCalorieResult!.source,
          isEstimated: lastCalorieResult!.isEstimated,
          foodType: lastCalorieResult!.foodType,
          confidence: lastCalorieResult!.confidence,
        );

        await _foodCacheRepository.saveFoodToCache(
          normalizedName: lastCalorieResult!.normalizedName,
          food: food,
        );
      }
    }

    widget.onAddFood(
      FoodItem(
        name: foodName,
        amount: amount,
        unit: selectedUnit,
        calories: estimatedCalories,
        protein: estimatedProtein,
        fats: estimatedFats,
        carbs: estimatedCarbs,
        nutritionSource: lastCalorieResult!.source,
        isEstimated: lastCalorieResult!.isEstimated,
      ),
    );

    foodController.clear();
    amountController.clear();

    setState(() {
      selectedUnit = 'Grams';
    });

    _resetValues();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    foodController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: GestureDetector(
            onTap: _addFood,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 26,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: AppColors.calendarCompleted,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Text(
                'Add food',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 18),

        _MealInputField(
          controller: foodController,
          hintText: 'Food name',
          onChanged: (_) => _estimateCalories(),
        ),

        const SizedBox(height: 10),

        _MealAmountField(
          controller: amountController,
          selectedUnit: selectedUnit,
          units: units,
          onUnitChanged: (value) {
            setState(() {
              selectedUnit = value;
            });

            _estimateCalories();
          },
          onChanged: (_) => _estimateCalories(),
        ),

        const SizedBox(height: 18),
        const Text(
          '( Calories are estimated based on\naverage nutritional values. )',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.homeBrown,
            fontSize: 10,
            height: 1.3,
            fontWeight: FontWeight.w400,
          ),
        ),

        const SizedBox(height: 18),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _MacroChip(
              title: 'Protein',
              value: estimatedProtein,
              isLoading: isEstimating,
            ),
            const SizedBox(width: 8),
            _MacroChip(
              title: 'Fats',
              value: estimatedFats,
              isLoading: isEstimating,
            ),
            const SizedBox(width: 8),
            _MacroChip(
              title: 'Carbs',
              value: estimatedCarbs,
              isLoading: isEstimating,
            ),
          ],
        ),

        const SizedBox(height: 8),

        _MacroChip(
          title: 'Calories',
          value: estimatedCalories,
          isLoading: isEstimating,
          wide: true,
          suffix: 'kcal',
        ),


      ],
    );
  }
}

class _MacroChip extends StatelessWidget {
  final String title;
  final int value;
  final bool isLoading;
  final bool wide;
  final String suffix;

  const _MacroChip({
    required this.title,
    required this.value,
    required this.isLoading,
    this.wide = false,
    this.suffix = 'g',
  });

  @override
  Widget build(BuildContext context) {
    String text = title;

    if (isLoading) {
      text = '...';
    } else if (value > 0) {
      text = '$value $suffix';
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: wide ? 150 : 70,
      height: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.homeCardBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        child: Text(
          text,
          key: ValueKey(text),
          style: const TextStyle(
            color: AppColors.homeBrown,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _MealInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;

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
        inputFormatters: inputFormatters,
        style: const TextStyle(
          color: AppColors.homeBrown,
          fontSize: 13,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: AppColors.homeBrown,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: AppColors.homeCardBackground,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 8,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _MealAmountField extends StatelessWidget {
  final TextEditingController controller;
  final String selectedUnit;
  final List<String> units;
  final ValueChanged<String> onUnitChanged;
  final ValueChanged<String>? onChanged;

  const _MealAmountField({
    required this.controller,
    required this.selectedUnit,
    required this.units,
    required this.onUnitChanged,
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
              style: const TextStyle(
                color: AppColors.homeBrown,
                fontSize: 13,
                height: 1,
              ),
              decoration: const InputDecoration(
                hintText: 'Amount',
                hintStyle: TextStyle(
                  color: AppColors.homeBrown,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  height: 1,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.only(
                  left: 18,
                  right: 8,
                ),
              ),
            ),
          ),

          Container(
            width: 1,
            height: 20,
            color: const Color(0xFFDCD9D1),
          ),

          SizedBox(
            width: 94,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedUnit,
                isExpanded: true,
                borderRadius: BorderRadius.circular(18),
                dropdownColor:
                AppColors.homeCardBackground,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: AppColors.homeBrown,
                ),
                style: const TextStyle(
                  color: AppColors.homeBrown,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 7,
                ),
                items: units.map((unit) {
                  return DropdownMenuItem<String>(
                    value: unit,
                    child: Text(
                      unit,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    onUnitChanged(value);
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