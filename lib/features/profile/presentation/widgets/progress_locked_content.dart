import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';

class ProgressLockedContent extends StatelessWidget {
  final String title;

  const ProgressLockedContent({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 70,
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
              textAlign: TextAlign.center,
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