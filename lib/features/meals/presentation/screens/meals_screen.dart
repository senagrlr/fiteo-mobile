import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/common/utils/app_snackbar.dart';
import 'package:fiteo_myapp/common/widgets/system_navigation_bar.dart';
import 'package:fiteo_myapp/features/home/data/home_repository.dart';
import 'package:fiteo_myapp/features/meals/data/meal_repository.dart';
import 'package:fiteo_myapp/features/meals/presentation/widgets/add_food_form.dart';
import 'package:fiteo_myapp/features/meals/presentation/widgets/food_list_item.dart';
import 'package:fiteo_myapp/features/meals/presentation/widgets/meal_swipe_header.dart';
import 'package:fiteo_myapp/features/meals/presentation/widgets/meals_loading_skeleton.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});

  @override
  State<MealsScreen> createState() =>
      _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  final MealRepository _mealRepository =
  MealRepository();

  final HomeRepository _homeRepository =
  HomeRepository();

  final PageController _mealPageController =
  PageController();

  int selectedMealIndex = 0;
  int streakDays = 0;
  bool isLoading = true;

  // Backend/internal key'ler.
  // Firestore uyumluluğu için İngilizce kalıyor.
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

  String _localizedMealName(
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

  int get totalCalories {
    return selectedFoods.fold(
      0,
          (total, item) => total + item.calories,
    );
  }

  double get totalProtein {
    return selectedFoods.fold<double>(
      0.0,
          (total, item) => total + item.protein,
    );
  }

  double get totalFats {
    return selectedFoods.fold<double>(
      0.0,
          (total, item) => total + item.fats,
    );
  }

  double get totalCarbs {
    return selectedFoods.fold<double>(
      0.0,
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
        amount: int.tryParse(item.amount) ?? 0,
        unit: item.unit,
        mealType: mealType,
        estimatedCalories: item.calories,
        protein: item.protein,
        fats: item.fats,
        carbs: item.carbs,
        nutritionSource: item.nutritionSource,
        isEstimated: item.isEstimated,
      );

      if (!mounted) return;

      final index =
      foodsByMeal[mealType]!.indexOf(item);

      if (index != -1) {
        setState(() {
          foodsByMeal[mealType]![index] =
              item.copyWith(
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
        context.l10n.couldNotAddFood,
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

    setState(() {
      mealFoods.removeAt(index);
    });

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

      final currentFoods =
      foodsByMeal[mealType];

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
        context.l10n.couldNotDeleteFood,
      );
    }
  }

  Future<void> _loadTodayMeals() async {
    try {
      final snapshot =
      await _mealRepository.getTodayMeals();

      final loadedFoods = {
        'Breakfast': <FoodItem>[],
        'Lunch': <FoodItem>[],
        'Dinner': <FoodItem>[],
        'Snacks': <FoodItem>[],
      };

      for (final doc in snapshot.docs) {
        final data = doc.data();

        final mealType =
            data['mealType'] as String? ??
                'Breakfast';

        final calories =
            data['estimatedCalories'] as int? ?? 0;

        final hasStoredMacros =
            data.containsKey('protein') &&
                data.containsKey('fats') &&
                data.containsKey('carbs');

        final item = FoodItem(
          id: doc.id,
          name: data['mealName'] as String? ?? '',
          amount: (data['amount'] ?? data['gram'] ?? '').toString(),
          unit: data['unit'] as String? ?? 'Grams',
          calories: calories,
          protein: hasStoredMacros
              ? (data['protein'] as num?)?.toDouble() ?? 0.0
              : calories * 0.07,

          fats: hasStoredMacros
              ? (data['fats'] as num?)?.toDouble() ?? 0.0
              : calories * 0.035,

          carbs: hasStoredMacros
              ? (data['carbs'] as num?)?.toDouble() ?? 0.0
              : calories * 0.10,
          nutritionSource:
          data['nutritionSource'] as String? ??
              (hasStoredMacros
                  ? 'unknown'
                  : 'legacy'),
          isEstimated:
          data['isEstimated'] as bool? ??
              !hasStoredMacros,
        );

        if (loadedFoods.containsKey(
          mealType,
        )) {
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
        context.l10n.couldNotLoadMeals,
      );
    }
  }

  Future<void> _loadStreak() async {
    try {
      final streak =
      await _homeRepository
          .getCurrentStreak();

      if (!mounted) return;

      setState(() {
        streakDays = streak;
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SystemNavigationBar(
        color: AppColors.generalBackground,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: AppColors.calendarCompleted,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
          child: Scaffold(
            backgroundColor: AppColors.generalBackground,
            extendBodyBehindAppBar: true,
            body: MealsLoadingContent(),
          ),
        ),
      );
    }

    final localizedSelectedMeal =
    _localizedMealName(
      context,
      selectedMeal,
    );

    return SystemNavigationBar(
      color: AppColors.generalBackground,
      child: AnnotatedRegion<
          SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor:
          AppColors.calendarCompleted,
          statusBarIconBrightness:
          Brightness.light,
          statusBarBrightness:
          Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor:
          AppColors.generalBackground,
          extendBodyBehindAppBar: true,
          body: ScrollConfiguration(
            behavior:
            const _NoOverscrollBehavior(),
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              physics:
              const ClampingScrollPhysics(),
              child: Column(
                children: [
                  MealSwipeHeader(
                    selectedIndex:
                    selectedMealIndex,
                    pageController:
                    _mealPageController,
                    meals: mealPages,
                    streakDays: streakDays,
                    calories: totalCalories,
                    fats: totalFats,
                    carbs: totalCarbs,
                    proteins: totalProtein,
                    onPageChanged: (index) {
                      setState(() {
                        selectedMealIndex =
                            index;
                      });
                    },
                  ),

                  Padding(
                    padding:
                    const EdgeInsets
                        .fromLTRB(
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

                        const SizedBox(
                          height: 38,
                        ),

                        Center(
                          child: Text(
                            context.l10n
                                .todaysMeal(
                              localizedSelectedMeal,
                            ),
                            style: AppTextStyles
                                .titleLarge
                                .copyWith(
                              color: AppColors
                                  .homeBrown,
                              fontSize: 22,
                              fontWeight:
                              FontWeight
                                  .w800,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        if (selectedFoods
                            .isEmpty)
                          SizedBox(
                            height: 170,
                            child: Stack(
                              clipBehavior:
                              Clip.none,
                              children: [
                                Positioned(
                                  top: -45,
                                  left: 20,
                                  right: 0,
                                  child:
                                  SizedBox(
                                    width: 250,
                                    height:
                                    250,
                                    child:
                                    Lottie.asset(
                                      'assets/animations/empty.json',
                                      repeat:
                                      true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          ...List.generate(
                            selectedFoods
                                .length,
                                (index) {
                              final mealType =
                                  selectedMeal;

                              final item =
                              foodsByMeal[
                              mealType]![index];

                              return FoodListItem(
                                item: item,
                                onDelete:
                                    () {
                                  _deleteFood(
                                    mealType:
                                    mealType,
                                    index:
                                    index,
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
      ),
    );
  }
}

class _NoOverscrollBehavior
    extends ScrollBehavior {
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
  final String unit;

  final int calories;
  final double protein;
  final double fats;
  final double carbs;

  final String nutritionSource;
  final bool isEstimated;

  const FoodItem({
    this.id,
    required this.name,
    required this.amount,
    required this.unit,
    required this.calories,
    this.protein = 0.0,
    this.fats = 0.0,
    this.carbs = 0.0,
    this.nutritionSource = 'unknown',
    this.isEstimated = false,
  });

  FoodItem copyWith({
    String? id,
    String? name,
    String? amount,
    String? unit,
    int? calories,
    double? protein,
    double? fats,
    double? carbs,
    String? nutritionSource,
    bool? isEstimated,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      fats: fats ?? this.fats,
      carbs: carbs ?? this.carbs,
      nutritionSource:
      nutritionSource ??
          this.nutritionSource,
      isEstimated:
      isEstimated ??
          this.isEstimated,
    );
  }
}