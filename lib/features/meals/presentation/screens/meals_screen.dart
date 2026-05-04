import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/home_header.dart';
import 'package:fiteo_myapp/features/meals/presentation/widgets/add_food_form.dart';
import 'package:fiteo_myapp/features/meals/presentation/widgets/food_list_item.dart';
import 'package:fiteo_myapp/features/meals/presentation/widgets/meal_type_selector.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  String selectedMeal = 'Breakfast';

  final Map<String, List<FoodItem>> foodsByMeal = {
    'Breakfast': [],
    'Lunch': [],
    'Dinner': [],
    'Snacks': [],
  };

  void _addFood(FoodItem item) {
    setState(() {
      foodsByMeal[selectedMeal]!.add(item);
    });
  }

  void _deleteFood(int index) {
    setState(() {
      foodsByMeal[selectedMeal]!.removeAt(index);
    });
  }

  void _editCalories(int index) async {
    final controller = TextEditingController(
      text: foodsByMeal[selectedMeal]![index].calories.toString(),
    );

    final newCalories = await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.homeCardBackground,
          title: const Text(
            'Edit calories',
            style: TextStyle(color: AppColors.homeBrown),
          ),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Calories',
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.homeBrown,
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.homeBrown,
              ),
              onPressed: () {
                Navigator.pop(
                  context,
                  int.tryParse(controller.text),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (newCalories != null) {
      setState(() {
        foodsByMeal[selectedMeal]![index] =
            foodsByMeal[selectedMeal]![index].copyWith(
              calories: newCalories,
            );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final foods = foodsByMeal[selectedMeal]!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeHeader(streakDays: 2),

              const SizedBox(height: 24),

              MealTypeSelector(
                selectedMeal: selectedMeal,
                onSelected: (meal) {
                  setState(() {
                    selectedMeal = meal;
                  });
                },
              ),

              const SizedBox(height: 25),

              Center(
                child: SizedBox(
                  width: 210,
                  height: 210,
                  child: ClipRect(
                    child: Transform.scale(
                      scale: 1.6,
                      child: Image.asset(
                        'assets/images/meal_plate.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              AddFoodForm(
                onAddFood: _addFood,
              ),

              const SizedBox(height: 34),

              Center(
                child: Text(
                  'Today’s $selectedMeal',
                  style: const TextStyle(
                    color: AppColors.homeBrown,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              if (foods.isEmpty)
                const Center(
                  child: Text(
                    'No food added yet.',
                    style: TextStyle(
                      color: AppColors.homeBrown,
                      fontSize: 14,
                    ),
                  ),
                )
              else
                ...List.generate(
                  foods.length,
                      (index) => FoodListItem(
                    item: foods[index],
                    onEdit: () => _editCalories(index),
                    onDelete: () => _deleteFood(index),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class FoodItem {
  final String name;
  final String amount;
  final int calories;

  const FoodItem({
    required this.name,
    required this.amount,
    required this.calories,
  });

  FoodItem copyWith({
    String? name,
    String? amount,
    int? calories,
  }) {
    return FoodItem(
      name: name ?? this.name,
      amount: amount ?? this.amount,
      calories: calories ?? this.calories,
    );
  }
}