import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/features/workout/presentation/screens/workout_screen.dart';

class ExerciseListItem extends StatelessWidget {
  final ExerciseItem item;
  final ValueChanged<int> onUpdateCalories;
  final VoidCallback onDelete;

  const ExerciseListItem({
    super.key,
    required this.item,
    required this.onUpdateCalories,
    required this.onDelete,
  });

  void _showExerciseDetails(BuildContext context) {
    final caloriesController = TextEditingController(
      text: item.caloriesBurned.toString(),
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        final keyboardHeight =
            MediaQuery.viewInsetsOf(bottomSheetContext).bottom;

        return AnimatedPadding(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(bottom: keyboardHeight),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight:
                MediaQuery.sizeOf(bottomSheetContext).height * 0.85,
              ),
              child: Container(
              padding: const EdgeInsets.fromLTRB(
                28,
                18,
                28,
                30,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                  Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.homeCardBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    item.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.homeBrown,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 22),

                  _ExerciseDetailRow(
                    title: 'Duration',
                    value: '${item.durationMinutes} min',
                  ),

                  const SizedBox(height: 32),

                  TextField(
                    controller: caloriesController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    style: const TextStyle(
                      color: AppColors.homeBrown,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Calories',
                      suffixText: 'kcal',
                      filled: true,
                      fillColor: AppColors.homeCardBackground,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 15,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: AppColors.homeBrown,
                          width: 1.2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        final calories = int.tryParse(
                          caloriesController.text.trim(),
                        );

                        if (calories == null) {
                          return;
                        }

                        Navigator.pop(bottomSheetContext);
                        onUpdateCalories(calories);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.homeBrown,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Save calories',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(bottomSheetContext);
                        onDelete();
                      },
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                      ),
                      label: const Text(
                        'Delete exercise',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFEEEE),
                        foregroundColor: const Color(0xFFB94A48),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
            ),
            ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Center(
        child: FractionallySizedBox(
          widthFactor: 0.84,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showExerciseDetails(context),
              borderRadius: BorderRadius.circular(20),
              child: Ink(
                height: 36,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.homeCardBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.homeBrown,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 21,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 11,
                      ),
                      color: const Color(0xFFDCD9D1),
                    ),
                    Text(
                      '${item.caloriesBurned} kcal',
                      style: const TextStyle(
                        color: AppColors.homeBrown,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ExerciseDetailRow extends StatelessWidget {
  final String title;
  final String value;

  const _ExerciseDetailRow({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.homeBrown,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),

        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.homeBrown,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}