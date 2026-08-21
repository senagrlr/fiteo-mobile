import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/progress_models.dart';

class ProgressMetricTabs extends StatelessWidget {
  final ProgressMetric selectedMetric;
  final ValueChanged<ProgressMetric> onChanged;

  const ProgressMetricTabs({
    super.key,
    required this.selectedMetric,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // WEIGHT
        Expanded(
          child: _MetricTab(
            label: context.l10n.weight,
            isSelected:
            selectedMetric == ProgressMetric.weight,
            onTap: () {
              onChanged(ProgressMetric.weight);
            },
          ),
        ),

        const SizedBox(width: 4),

        // NUTRITION
        Expanded(
          child: _MetricTab(
            label: context.l10n.nutrition,
            isSelected:
            selectedMetric == ProgressMetric.nutrition,
            onTap: () {
              onChanged(ProgressMetric.nutrition);
            },
          ),
        ),

        const SizedBox(width: 4),

        // WORKOUT
        Expanded(
          child: _MetricTab(
            label: context.l10n.workout,
            isSelected:
            selectedMetric == ProgressMetric.workout,
            onTap: () {
              onChanged(ProgressMetric.workout);
            },
          ),
        ),

        const SizedBox(width: 4),

        // WATER
        Expanded(
          child: _MetricTab(
            label: context.l10n.water,
            isSelected:
            selectedMetric == ProgressMetric.water,
            onTap: () {
              onChanged(ProgressMetric.water);
            },
          ),
        ),
      ],
    );
  }
}

class _MetricTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _MetricTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 180,
        ),
        curve: Curves.easeOut,
        height: 38,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.surfaceSoft
              : Colors.transparent,
          borderRadius: BorderRadius.circular(19),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            maxLines: 1,
            style: AppTextStyles.labelSmall.copyWith(
              color: isSelected
                  ? AppColors.homeBrown
                  : AppColors.planTrackingSecondaryLabel,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}