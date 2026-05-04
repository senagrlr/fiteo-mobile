import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/features/workout/presentation/screens/workout_screen.dart';

class ExerciseListItem extends StatelessWidget {
  final ExerciseItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ExerciseListItem({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: onEdit,
            child: const Icon(
              Icons.edit_outlined,
              color: AppColors.mealIconBrown,
              size: 20,
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: AppColors.homeCardBackground,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.homeBrown,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 24,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    color: const Color(0xFFDCD9D1),
                  ),
                  Text(
                    '${item.durationMinutes} min',
                    style: const TextStyle(
                      color: AppColors.homeBrown,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 24,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    color: const Color(0xFFDCD9D1),
                  ),
                  Text(
                    '${item.caloriesBurned} kcal',
                    style: const TextStyle(
                      color: AppColors.homeBrown,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 8),

          GestureDetector(
            onTap: onDelete,
            child: const Icon(
              Icons.delete_outline,
              color: AppColors.mealIconBrown,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}