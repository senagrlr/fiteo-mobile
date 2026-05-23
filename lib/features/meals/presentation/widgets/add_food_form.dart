import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/features/meals/presentation/screens/meals_screen.dart';
import 'package:fiteo_myapp/features/meals/data/meal_calorie_service.dart';
import 'package:fiteo_myapp/features/meals/data/food_calorie_cache_repository.dart';
import 'dart:async';

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

  Timer? _debounce;
  int _calorieRequestId = 0;
  MealCalorieResult? lastCalorieResult;
  int estimatedCalories = 0;
  bool isEstimating = false;

  void _estimateCalories() {
    _debounce?.cancel();

    final requestId = ++_calorieRequestId;

    _debounce = Timer(const Duration(milliseconds: 700), () async {
      final foodName = foodController.text.trim();
      final gram = int.tryParse(amountController.text.trim()) ?? 0;

      if (foodName.isEmpty || gram == 0) {
        if (!mounted) return;

        setState(() {
          estimatedCalories = 0;
          isEstimating = false;
          lastCalorieResult = null;
        });
        return;
      }

      if (!mounted) return;

      setState(() {
        isEstimating = true;
      });

      try {
        final result = await _mealCalorieService.estimateMealCalories(
          foodName: foodName,
          gram: gram,
        );

        if (!mounted || requestId != _calorieRequestId) return;

        setState(() {
          lastCalorieResult = result;
          estimatedCalories = result?.estimatedCalories ?? 0;
          isEstimating = false;
        });
      } catch (e) {
        if (!mounted || requestId != _calorieRequestId) return;

        setState(() {
          estimatedCalories = 0;
          isEstimating = false;
          lastCalorieResult = null;
        });
      }
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

    await _foodCacheRepository.saveFoodToCache(
      foodName: lastCalorieResult!.foodName,
      normalizedName: lastCalorieResult!.normalizedName,
      caloriesPer100g: lastCalorieResult!.caloriesPer100g,
      source: lastCalorieResult!.source,
      foodType: lastCalorieResult!.foodType,
      confidence: lastCalorieResult!.confidence,
    );

    widget.onAddFood(
      FoodItem(
        name: foodName,
        amount: amount,
        calories: estimatedCalories,
      ),
    );

    foodController.clear();
    amountController.clear();

    setState(() {
      estimatedCalories = 0;
      lastCalorieResult = null;
    });
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
            onTap: () async {
              await _addFood();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
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

        _MealInputField(
          controller: amountController,
          hintText: 'Gram',
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (_) => _estimateCalories(),
        ),

        const SizedBox(height: 18),

        Container(
          width: 150,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.homeCardBackground,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            isEstimating
                ? 'Calculating...'
                : estimatedCalories == 0
                ? 'Calories'
                : '$estimatedCalories kcal',
            style: const TextStyle(
              color: AppColors.homeBrown,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          '( Calories are estimated based on\naverage nutritional values. )',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.homeBrown,
            fontSize: 10,
            height: 1.3,
          ),
        ),
      ],
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
        ),
      ),
    );
  }
}