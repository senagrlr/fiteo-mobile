import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/progress_models.dart';

class ProgressNutritionTabs extends StatelessWidget {
  final ProgressNutritionMetric selectedMetric;
  final ValueChanged<ProgressNutritionMetric> onChanged;

  const ProgressNutritionTabs({
    super.key,
    required this.selectedMetric,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _item(context, ProgressNutritionMetric.calories, context.l10n.calories),
        _item(context, ProgressNutritionMetric.protein, context.l10n.protein),
        _item(context, ProgressNutritionMetric.carbs, context.l10n.carbs),
        _item(context, ProgressNutritionMetric.fat, context.l10n.fat),
      ],
    );
  }

  Widget _item(
      BuildContext context,
      ProgressNutritionMetric metric,
      String label,
      ) {
    final selected = selectedMetric == metric;

    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(metric),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: selected ? AppColors.surfaceSoft : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: selected
                    ? AppColors.homeBrown
                    : AppColors.planTrackingSecondaryLabel,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}