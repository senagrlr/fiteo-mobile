import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/common/utils/app_snackbar.dart';
import 'package:fiteo_myapp/common/widgets/system_navigation_bar.dart';
import 'package:fiteo_myapp/features/home/data/home_repository.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/home_header.dart';
import 'package:fiteo_myapp/features/workout/data/workout_repository.dart';
import 'package:fiteo_myapp/features/workout/presentation/widgets/add_exercise_form.dart';
import 'package:fiteo_myapp/features/workout/presentation/widgets/exercise_list_item.dart';
import 'package:fiteo_myapp/features/workout/presentation/widgets/workout_loading_skeleton.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({
    super.key,
  });

  @override
  State<WorkoutScreen> createState() =>
      _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final List<ExerciseItem> exercises = [];

  final WorkoutRepository _workoutRepository =
  WorkoutRepository();

  final HomeRepository _homeRepository =
  HomeRepository();

  bool isLoading = true;
  int streakDays = 0;

  @override
  void initState() {
    super.initState();

    _loadTodayWorkouts();
    _loadStreak();
  }

  Future<void> _addExercise(
      ExerciseItem item,
      ) async {
    setState(() {
      exercises.add(item);
    });

    try {
      final id =
      await _workoutRepository.addWorkout(
        workoutName: item.name,
        durationMinutes: item.durationMinutes,
        intensity: item.intensity,
        estimatedCaloriesBurned:
        item.caloriesBurned,
      );

      if (!mounted) return;

      final index = exercises.indexOf(item);

      if (index != -1) {
        setState(() {
          exercises[index] = item.copyWith(
            id: id,
          );
        });
      }

      _loadStreak();
    } catch (_) {
      if (!mounted) return;

      setState(() {
        exercises.remove(item);
      });

      AppSnackbar.showError(
        context,
        context.l10n.couldNotAddExercise,
      );
    }
  }

  Future<void> _updateCalories({
    required int index,
    required int calories,
  }) async {
    if (index < 0 ||
        index >= exercises.length) {
      return;
    }

    final oldItem = exercises[index];

    setState(() {
      exercises[index] = oldItem.copyWith(
        caloriesBurned: calories,
      );
    });

    if (oldItem.id == null) {
      return;
    }

    try {
      await _workoutRepository.updateWorkoutCalories(
        workoutId: oldItem.id!,
        calories: calories,
      );

      _loadStreak();
    } catch (_) {
      if (!mounted) return;

      final currentIndex =
      exercises.indexWhere(
            (exercise) =>
        exercise.id == oldItem.id,
      );

      if (currentIndex != -1) {
        setState(() {
          exercises[currentIndex] =
              oldItem;
        });
      }

      AppSnackbar.showError(
        context,
        context.l10n.couldNotUpdateCalories,
      );
    }
  }

  Future<void> _deleteExercise(
      int index,
      ) async {
    if (index < 0 ||
        index >= exercises.length) {
      return;
    }

    final item = exercises[index];

    setState(() {
      exercises.removeAt(index);
    });

    if (item.id == null) {
      return;
    }

    try {
      await _workoutRepository.deleteWorkout(
        item.id!,
      );

      _loadStreak();
    } catch (_) {
      if (!mounted) return;

      final safeIndex = index.clamp(
        0,
        exercises.length,
      );

      setState(() {
        exercises.insert(
          safeIndex,
          item,
        );
      });

      AppSnackbar.showError(
        context,
        context.l10n.couldNotDeleteExercise,
      );
    }
  }

  Future<void> _loadTodayWorkouts() async {
    try {
      final snapshot =
      await _workoutRepository
          .getTodayWorkouts();

      final loadedExercises =
      <ExerciseItem>[];

      for (final doc in snapshot.docs) {
        final data = doc.data();

        loadedExercises.add(
          ExerciseItem(
            id: doc.id,
            name:
            data['workoutName']
            as String? ??
                '',
            durationMinutes:
            data['durationMinutes']
            as int? ??
                0,
            intensity:
            data['intensity']
            as String? ??
                '',
            caloriesBurned:
            data['estimatedCaloriesBurned']
            as int? ??
                0,
          ),
        );
      }

      if (!mounted) return;

      setState(() {
        exercises
          ..clear()
          ..addAll(
            loadedExercises,
          );

        isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      AppSnackbar.showError(
        context,
        context.l10n.couldNotLoadExercises,
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
        color: Colors.white,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: WorkoutLoadingContent(),
        ),
      );
    }

    return SystemNavigationBar(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              24,
              22,
              24,
              20,
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                HomeHeader(
                  streakDays: streakDays,
                ),

                const SizedBox(height: 42),

                Center(
                  child: SizedBox(
                    width: 210,
                    height: 170,
                    child: Transform.scale(
                      scale: 1.5,
                      child: Image.asset(
                        'assets/images/workout_equipment.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 45),

                AddExerciseForm(
                  onAddExercise: _addExercise,
                ),

                const SizedBox(height: 42),

                Center(
                  child: Text(
                    context.l10n.todaysExercises,
                    style: AppTextStyles
                        .titleMedium
                        .copyWith(
                      color: AppColors.homeBrown,
                      fontSize: 18,
                      fontWeight:
                      FontWeight.w800,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                if (exercises.isEmpty)
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
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ...List.generate(
                    exercises.length,
                        (index) {
                      return ExerciseListItem(
                        item: exercises[index],
                        onUpdateCalories:
                            (newCalories) {
                          _updateCalories(
                            index: index,
                            calories:
                            newCalories,
                          );
                        },
                        onDelete: () {
                          _deleteExercise(
                            index,
                          );
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ExerciseItem {
  final String? id;
  final String name;
  final int durationMinutes;
  final String intensity;
  final int caloriesBurned;

  const ExerciseItem({
    this.id,
    required this.name,
    required this.durationMinutes,
    required this.intensity,
    required this.caloriesBurned,
  });

  ExerciseItem copyWith({
    String? id,
    String? name,
    int? durationMinutes,
    String? intensity,
    int? caloriesBurned,
  }) {
    return ExerciseItem(
      id: id ?? this.id,
      name: name ?? this.name,
      durationMinutes:
      durationMinutes ??
          this.durationMinutes,
      intensity:
      intensity ?? this.intensity,
      caloriesBurned:
      caloriesBurned ??
          this.caloriesBurned,
    );
  }
}