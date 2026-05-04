import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/home_header.dart';
import 'package:fiteo_myapp/features/workout/presentation/widgets/add_exercise_form.dart';
import 'package:fiteo_myapp/features/workout/presentation/widgets/exercise_list_item.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final List<ExerciseItem> exercises = [];

  void _addExercise(ExerciseItem item) {
    setState(() {
      exercises.add(item);
    });
  }

  void _deleteExercise(int index) {
    setState(() {
      exercises.removeAt(index);
    });
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
      setState(() {
        exercises[index] = exercises[index].copyWith(
          caloriesBurned: newCalories,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeHeader(streakDays: 2),

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
  final String name;
  final int durationMinutes;
  final String intensity;
  final int caloriesBurned;

  const ExerciseItem({
    required this.name,
    required this.durationMinutes,
    required this.intensity,
    required this.caloriesBurned,
  });

  ExerciseItem copyWith({
    String? name,
    int? durationMinutes,
    String? intensity,
    int? caloriesBurned,
  }) {
    return ExerciseItem(
      name: name ?? this.name,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      intensity: intensity ?? this.intensity,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
    );
  }
}