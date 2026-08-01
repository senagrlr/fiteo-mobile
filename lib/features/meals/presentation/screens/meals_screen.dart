import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/common/utils/app_snackbar.dart';
import 'package:fiteo_myapp/features/home/data/home_repository.dart';
import 'package:fiteo_myapp/features/meals/data/meal_repository.dart';
import 'package:fiteo_myapp/features/meals/presentation/widgets/add_food_form.dart';
import 'package:fiteo_myapp/features/meals/presentation/widgets/food_list_item.dart';
import 'package:fiteo_myapp/features/meals/presentation/widgets/meal_swipe_header.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  final _mealRepository = MealRepository();
  final _homeRepository = HomeRepository();

  final PageController _mealPageController = PageController();

  int selectedMealIndex = 0;
  int streakDays = 0;
  bool isLoading = true;

  final List<MealHeaderData> mealPages = const [
    MealHeaderData(
      name: 'Breakfast',
      imagePath: 'assets/images/breakfast_plate.png',
    ),
    MealHeaderData(
      name: 'Lunch',
      imagePath: 'assets/images/lunch_plate.png',
    ),
    MealHeaderData(
      name: 'Dinner',
      imagePath: 'assets/images/dinner_plate.png',
    ),
    MealHeaderData(
      name: 'Snacks',
      imagePath: 'assets/images/snacks_plate.png',
    ),
  ];

  final Map<String, List<FoodItem>> foodsByMeal = {
    'Breakfast': [],
    'Lunch': [],
    'Dinner': [],
    'Snacks': [],
  };

  String get selectedMeal {
    return mealPages[selectedMealIndex].name;
  }

  List<FoodItem> get selectedFoods {
    return foodsByMeal[selectedMeal] ?? [];
  }

  int get totalCalories {
    return selectedFoods.fold(
      0,
          (total, item) => total + item.calories,
    );
  }

  int get totalProtein {
    return selectedFoods.fold(
      0,
          (total, item) => total + item.protein,
    );
  }

  int get totalFats {
    return selectedFoods.fold(
      0,
          (total, item) => total + item.fats,
    );
  }

  int get totalCarbs {
    return selectedFoods.fold(
      0,
          (total, item) => total + item.carbs,
    );
  }

  @override
  void initState() {
    super.initState();

    _loadTodayMeals();
    _loadStreak();
  }

  @override
  void dispose() {
    _mealPageController.dispose();
    super.dispose();
  }

  Future<void> _addFood(FoodItem item) async {
    final mealType = selectedMeal;

    setState(() {
      foodsByMeal[mealType]!.add(item);
    });

    try {
      final id = await _mealRepository.addMeal(
        mealName: item.name,
        gram: int.tryParse(item.amount) ?? 0,
        mealType: mealType,
        estimatedCalories: item.calories,
      );

      if (!mounted) return;

      final index = foodsByMeal[mealType]!.indexOf(item);

      if (index != -1) {
        setState(() {
          foodsByMeal[mealType]![index] = item.copyWith(
            id: id,
          );
        });
      }

      _loadStreak();
    } catch (_) {
      if (!mounted) return;

      setState(() {
        foodsByMeal[mealType]!.remove(item);
      });

      AppSnackbar.showError(
        context,
        'Could not add food.',
      );
    }
  }

  Future<void> _deleteFood({
    required String mealType,
    required int index,
  }) async {
    final mealFoods = foodsByMeal[mealType];

    if (mealFoods == null ||
        index < 0 ||
        index >= mealFoods.length) {
      return;
    }

    final deletedItem = mealFoods[index];

    // Önce arayüzden kaldırıyoruz.
    setState(() {
      mealFoods.removeAt(index);
    });

    // Henüz Firestore'a kaydedilmemişse başka işlem gerekmiyor.
    if (deletedItem.id == null) {
      return;
    }

    try {
      await _mealRepository.deleteMeal(
        deletedItem.id!,
      );

      await _loadStreak();
    } catch (_) {
      if (!mounted) return;

      // Silme başarısız olursa eski yerine geri koyuyoruz.
      final currentFoods = foodsByMeal[mealType];

      if (currentFoods != null) {
        final safeIndex = index.clamp(
          0,
          currentFoods.length,
        );

        setState(() {
          currentFoods.insert(
            safeIndex,
            deletedItem,
          );
        });
      }

      AppSnackbar.showError(
        context,
        'Could not delete food.',
      );
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

        final mealType =
            data['mealType'] as String? ?? 'Breakfast';

        final calories =
            data['estimatedCalories'] as int? ?? 0;

        final item = FoodItem(
          id: doc.id,
          name: data['mealName'] as String? ?? '',
          amount: (data['gram'] ?? '').toString(),
          calories: calories,
          protein: (calories * 0.07).round(),
          fats: (calories * 0.035).round(),
          carbs: (calories * 0.10).round(),
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
    } catch (_) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      AppSnackbar.showError(
        context,
        'Could not load meals.',
      );
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
    if (isLoading) {
      return const AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: AppColors.calendarCompleted,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.calendarCompleted,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        body: ScrollConfiguration(
          behavior: const _NoOverscrollBehavior(),
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                MealSwipeHeader(
                  selectedIndex: selectedMealIndex,
                  pageController: _mealPageController,
                  meals: mealPages,
                  streakDays: streakDays,
                  calories: totalCalories,
                  fats: totalFats,
                  carbs: totalCarbs,
                  proteins: totalProtein,
                  onPageChanged: (index) {
                    setState(() {
                      selectedMealIndex = index;
                    });
                  },
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    28,
                    22,
                    28,
                    20,
                  ),
                  child: Column(
                    children: [
                      AddFoodForm(
                        onAddFood: _addFood,
                      ),

                      const SizedBox(height: 38),

                      Center(
                        child: Text(
                          'Today’s $selectedMeal',
                          style: const TextStyle(
                            color: AppColors.homeBrown,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      if (selectedFoods.isEmpty)
                        SizedBox(
                          height: 170,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                top: -45,
                                left: 20,
                                right: 0,
                                child: SizedBox(
                                  width: 250,
                                  height: 250,
                                  child: Lottie.asset(
                                    'assets/animations/empty.json',
                                    repeat: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ...List.generate(
                          selectedFoods.length,
                              (index) {
                            final mealType = selectedMeal;
                            final item =
                            foodsByMeal[mealType]![index];

                            return FoodListItem(
                              item: item,
                              onDelete: () {
                                _deleteFood(
                                  mealType: mealType,
                                  index: index,
                                );
                              },
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NoOverscrollBehavior extends ScrollBehavior {
  const _NoOverscrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(
      BuildContext context,
      ) {
    return const ClampingScrollPhysics();
  }

  @override
  Widget buildOverscrollIndicator(
      BuildContext context,
      Widget child,
      ScrollableDetails details,
      ) {
    return child;
  }
}

class FoodItem {
  final String? id;
  final String name;
  final String amount;
  final int calories;
  final int protein;
  final int fats;
  final int carbs;

  const FoodItem({
    this.id,
    required this.name,
    required this.amount,
    required this.calories,
    this.protein = 0,
    this.fats = 0,
    this.carbs = 0,
  });

  FoodItem copyWith({
    String? id,
    String? name,
    String? amount,
    int? calories,
    int? protein,
    int? fats,
    int? carbs,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      fats: fats ?? this.fats,
      carbs: carbs ?? this.carbs,
    );
  }
}