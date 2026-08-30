import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';

class PlanTrackingLockedContent extends StatelessWidget {
  final int selectedTab;

  const PlanTrackingLockedContent({
    super.key,
    required this.selectedTab,
  });

  @override
  Widget build(BuildContext context) {
    final title = selectedTab == 0
        ? 'Overview'
        : 'Plan';

    return Container(
      width: double.infinity,
      color: AppColors.surfacePrimary,
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.lock_rounded,
              size: 46,
              color: AppColors.homeBrown,
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.homeBrown,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This feature is available with Premium.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.homeBrown,
              ),
            ),
          ],
        ),
      ),
    );
  }
}