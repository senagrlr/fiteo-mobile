import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/features/meals/presentation/screens/meals_screen.dart';

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

  int estimatedCalories = 0;

  void _estimateCalories() {
    final amount = int.tryParse(amountController.text) ?? 0;

    setState(() {
      estimatedCalories = amount == 0 ? 0 : (amount * 1.5).round();
    });
  }

  void _addFood() {
    final foodName = foodController.text.trim();
    final amount = amountController.text.trim();

    if (foodName.isEmpty || amount.isEmpty || estimatedCalories == 0) return;

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
    });
  }

  @override
  void dispose() {
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
          hintText: 'Gram / piece',
          keyboardType: TextInputType.number,
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
            estimatedCalories == 0
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

  const _MealInputField({
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.onChanged,
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