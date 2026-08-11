import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';

class SavedRecipeCard extends StatelessWidget {
  final String recipeName;
  final int calories;
  final VoidCallback? onTap;

  const SavedRecipeCard({
    super.key,
    required this.recipeName,
    required this.calories,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.calendarCompleted,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            children: [
              Expanded(
                flex: 6,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  alignment: Alignment.center,
                  color: AppColors.calendarCompleted,
                  child: Text(
                    recipeName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  color: AppColors.savedRecipeCaloriesBackground,
                  child: Text(
                    '$calories kcal',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.homeBrown,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}