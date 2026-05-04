import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';

class MealTypeSelector extends StatelessWidget {
  final String selectedMeal;
  final ValueChanged<String> onSelected;

  const MealTypeSelector({
    super.key,
    required this.selectedMeal,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final meals = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: meals.map((meal) {
        final isSelected = selectedMeal == meal;

        return GestureDetector(
          onTap: () => onSelected(meal),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.calendarCompleted
                  : AppColors.calendarInactive,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              meal,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}