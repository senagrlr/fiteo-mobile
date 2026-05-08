import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/home_header.dart';
import 'package:fiteo_myapp/features/meals/presentation/widgets/add_food_form.dart';
import 'package:fiteo_myapp/features/meals/presentation/widgets/food_list_item.dart';
import 'package:fiteo_myapp/features/meals/presentation/widgets/meal_type_selector.dart';
import 'package:fiteo_myapp/features/meals/data/meal_repository.dart';
import 'package:fiteo_myapp/features/home/data/home_repository.dart';
import 'package:fiteo_myapp/common/utils/app_snackbar.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  String selectedMeal = 'Breakfast';
  final _mealRepository = MealRepository();
  bool isLoading = true;

  final _homeRepository = HomeRepository();
  int streakDays = 0;

  final Map<String, List<FoodItem>> foodsByMeal = {
    'Breakfast': [],
    'Lunch': [],
    'Dinner': [],
    'Snacks': [],
  };

  @override
  void initState() {
    super.initState();
    _loadTodayMeals();
    _loadStreak();
  }

  Future<void> _addFood(FoodItem item) async {
    try {
      final id = await _mealRepository.addMeal(
        mealName: item.name,
        gram: int.tryParse(item.amount) ?? 0,
        mealType: selectedMeal,
        estimatedCalories: item.calories,
      );

      setState(() {
        foodsByMeal[selectedMeal]!.add(
          item.copyWith(id: id),
        );
      });

      await _loadStreak();

    } catch (e) {
      if (!mounted) return;

      AppSnackbar.showError(context, 'Could not add food.');
    }
  }

  Future<void> _deleteFood(int index) async {
    final item = foodsByMeal[selectedMeal]![index];

    if (item.id == null) {
      setState(() {
        foodsByMeal[selectedMeal]!.removeAt(index);
      });

      return;
    }

    try {
      await _mealRepository.deleteMeal(item.id!);

      setState(() {
        foodsByMeal[selectedMeal]!.removeAt(index);
      });

      await _loadStreak();

    } catch (e) {
      if (!mounted) return;

      AppSnackbar.showError(context, 'Could not delete food.');
    }
  }

  Future<void> _loadTodayMeals() async {
    try {
      final snapshot = await _mealRepository.getTodayMeals();

      final loadedFoods = {
        'Breakfast': <FoodItem>[],
        'Lunch': <FoodItem>[],
        'Dinner': <FoodItem>[],
        'Snacks': <FoodItem>[],
      };

      for (final doc in snapshot.docs) {
        final data = doc.data();

        final mealType = data['mealType'] as String? ?? 'Breakfast';

        final item = FoodItem(
          id: doc.id,
          name: data['mealName'] as String? ?? '',
          amount: (data['gram'] ?? '').toString(),
          calories: data['estimatedCalories'] as int? ?? 0,
        );

        if (loadedFoods.containsKey(mealType)) {
          loadedFoods[mealType]!.add(item);
        }
      }

      if (!mounted) return;

      setState(() {
        foodsByMeal
          ..clear()
          ..addAll(loadedFoods);

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      AppSnackbar.showError(context, 'Could not load meals.');
    }
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
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
      final item = foodsByMeal[selectedMeal]![index];

      try {
        if (item.id != null) {
          await _mealRepository.updateMealCalories(
            mealId: item.id!,
            calories: newCalories,
          );
        }

        setState(() {
          foodsByMeal[selectedMeal]![index] =
              item.copyWith(calories: newCalories);
        });

        await _loadStreak();

      } catch (e) {
        if (!mounted) return;

        AppSnackbar.showError(context, 'Could not update calories.');
      }
    }
  }

  Future<void> _loadStreak() async {
    try {
      final streak = await _homeRepository.getCurrentStreak();

      if (!mounted) return;

      setState(() {
        streakDays = streak;
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final foods = foodsByMeal[selectedMeal]!;
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeader(streakDays: streakDays),

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
  final String? id;
  final String name;
  final String amount;
  final int calories;

  const FoodItem({
    this.id,
    required this.name,
    required this.amount,
    required this.calories,
  });

  FoodItem copyWith({
    String? id,
    String? name,
    String? amount,
    int? calories,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      calories: calories ?? this.calories,
    );
  }
}