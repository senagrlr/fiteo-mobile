import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/features/meals/presentation/screens/meals_screen.dart';

class FoodListItem extends StatelessWidget {
  final FoodItem item;
  final VoidCallback? onDelete;

  const FoodListItem({
    super.key,
    required this.item,
    this.onDelete,
  });

  void _showFoodDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return Container(
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
                _NutritionRow(
                  title: 'Calories',
                  value: '${item.calories} kcal',
                ),
                _NutritionRow(
                  title: 'Protein',
                  value: '${item.protein} g',
                ),
                _NutritionRow(
                  title: 'Fats',
                  value: '${item.fats} g',
                ),
                _NutritionRow(
                  title: 'Carbs',
                  value: '${item.carbs} g',
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(bottomSheetContext);
                      onDelete?.call();
                    },
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                    ),
                    label: const Text('Delete food'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      const Color(0xFFFFEEEE),
                      foregroundColor:
                      const Color(0xFFB94A48),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
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
              onTap: () => _showFoodDetails(context),
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
                      '${item.calories} kcal',
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

class _NutritionRow extends StatelessWidget {
  final String title;
  final String value;

  const _NutritionRow({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
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
      ),
    );
  }
}