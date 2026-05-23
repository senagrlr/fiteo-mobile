import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/home_header.dart';
import 'package:fiteo_myapp/features/workout/presentation/widgets/add_exercise_form.dart';
import 'package:fiteo_myapp/features/workout/presentation/widgets/exercise_list_item.dart';
import 'package:fiteo_myapp/features/workout/data/workout_repository.dart';
import 'package:fiteo_myapp/features/home/data/home_repository.dart';
import 'package:fiteo_myapp/common/utils/app_snackbar.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final List<ExerciseItem> exercises = [];
  final _workoutRepository = WorkoutRepository();
  bool isLoading = true;

  final _homeRepository = HomeRepository();
  int streakDays = 0;

  @override
  void initState() {
    super.initState();
    _loadTodayWorkouts();
    _loadStreak();
  }

  Future<void> _addExercise(ExerciseItem item) async {
    setState(() {
      exercises.add(item);
    });

    try {
      final id = await _workoutRepository.addWorkout(
        workoutName: item.name,
        durationMinutes: item.durationMinutes,
        intensity: item.intensity,
        estimatedCaloriesBurned: item.caloriesBurned,
      );

      if (!mounted) return;

      final index = exercises.indexOf(item);

      if (index != -1) {
        setState(() {
          exercises[index] = item.copyWith(id: id);
        });
      }

      _loadStreak();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        exercises.remove(item);
      });

      AppSnackbar.showError(context, 'Could not add exercise.');
    }
  }

  Future<void> _deleteExercise(int index) async {
    final item = exercises[index];

    setState(() {
      exercises.removeAt(index);
    });

    if (item.id == null) {
      return;
    }

    try {
      await _workoutRepository.deleteWorkout(item.id!);

      _loadStreak();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        exercises.insert(index, item);
      });

      AppSnackbar.showError(context, 'Could not delete exercise.');
    }
  }

  Future<void> _loadTodayWorkouts() async {
    try {
      final snapshot = await _workoutRepository.getTodayWorkouts();

      final loadedExercises = <ExerciseItem>[];

      for (final doc in snapshot.docs) {
        final data = doc.data();

        loadedExercises.add(
          ExerciseItem(
            id: doc.id,
            name: data['workoutName'] as String? ?? '',
            durationMinutes: data['durationMinutes'] as int? ?? 0,
            intensity: data['intensity'] as String? ?? '',
            caloriesBurned: data['estimatedCaloriesBurned'] as int? ?? 0,
          ),
        );
      }

      if (!mounted) return;

      setState(() {
        exercises
          ..clear()
          ..addAll(loadedExercises);

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      AppSnackbar.showError(context, 'Could not load exercises.');
    }
  }

  void _editCalories(int index) async {
    final controller = TextEditingController(
      text: exercises[index].caloriesBurned.toString(),
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
            style: const TextStyle(color: AppColors.homeBrown),
            decoration: const InputDecoration(
              hintText: 'Calories burned',
              hintStyle: TextStyle(color: AppColors.homeBrown),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.homeBrown),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  int.tryParse(controller.text),
                );
              },
              child: const Text(
                'Save',
                style: TextStyle(color: AppColors.homeBrown),
              ),
            ),
          ],
        );
      },
    );

    if (newCalories != null) {
      final item = exercises[index];

      final oldItem = item;

      setState(() {
        exercises[index] = item.copyWith(
          caloriesBurned: newCalories,
        );
      });

      try {
        if (item.id != null) {
          await _workoutRepository.updateWorkoutCalories(
            workoutId: item.id!,
            calories: newCalories,
          );
        }

        _loadStreak();
      } catch (e) {
        if (!mounted) return;

        setState(() {
          exercises[index] = oldItem;
        });

        AppSnackbar.showError(context, 'Could not update exercise.');
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

              const Center(
                child: Text(
                  'Today’s Exercises',
                  style: TextStyle(
                    color: AppColors.homeBrown,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              if (exercises.isEmpty)
                const Center(
                  child: Text(
                    'No exercise added yet.',
                    style: TextStyle(
                      color: AppColors.homeBrown,
                      fontSize: 14,
                    ),
                  ),
                )
              else
                ...List.generate(
                  exercises.length,
                      (index) => ExerciseListItem(
                    item: exercises[index],
                    onEdit: () => _editCalories(index),
                    onDelete: () => _deleteExercise(index),
                  ),
                ),
            ],
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
      durationMinutes: durationMinutes ?? this.durationMinutes,
      intensity: intensity ?? this.intensity,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
    );
  }
}