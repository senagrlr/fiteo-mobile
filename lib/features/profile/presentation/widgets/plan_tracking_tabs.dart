import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';

class PlanTrackingTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const PlanTrackingTabs({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _TabItem(
          label: context.l10n.overview,
          isSelected: selectedIndex == 0,
          onTap: () => onChanged(0),
        ),

        const SizedBox(width: 14),

        _TabItem(
          label: context.l10n.plan,
          isSelected: selectedIndex == 1,
          onTap: () => onChanged(1),
        ),
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({
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
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.planTrackingTabSelectedBackground
              : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.labelMedium.copyWith(
            color: isSelected
                ? AppColors.onPrimary
                : AppColors.planTrackingTabInactive,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}