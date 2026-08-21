import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';

class WeeklyBestWorstDay extends StatelessWidget {
  final bool showBestDay;
  final ValueChanged<bool> onChanged;

  const WeeklyBestWorstDay({
    super.key,
    required this.showBestDay,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _DayTab(
          label: context.l10n.bestDay,
          isSelected: showBestDay,
          onTap: () {
            onChanged(true);
          },
        ),

        const SizedBox(width: 34),

        _DayTab(
          label: context.l10n.worstDay,
          isSelected: !showBestDay,
          onTap: () {
            onChanged(false);
          },
        ),
      ],
    );
  }
}

class _DayTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DayTab({
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

        width: 108,
        height: 34,

        alignment: Alignment.center,

        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.authButtonGreen
              : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),

        child: Text(
          label,
          maxLines: 1,
          style: AppTextStyles.labelSmall.copyWith(
            color: isSelected
                ? AppColors.onPrimary
                : AppColors.planTrackingSecondaryLabel,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}