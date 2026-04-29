import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';

class OnboardingIndicator extends StatelessWidget {
  final int currentIndex;
  final int itemCount;

  const OnboardingIndicator({
    super.key,
    required this.currentIndex,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        itemCount,
            (index) => Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == currentIndex
                ? AppColors.onboardingDotActive
                : AppColors.onboardingDotInactive,
          ),
        ),
      ),
    );
  }
}