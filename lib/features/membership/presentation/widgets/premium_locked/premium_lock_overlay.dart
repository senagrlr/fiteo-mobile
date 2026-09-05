import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/features/membership/presentation/premium_navigation.dart';

class PremiumLockOverlay extends StatelessWidget {
  const PremiumLockOverlay({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.lock_rounded,
              size: 62,
              color: AppColors.homeBrown,
            ),

            const SizedBox(height: 12),

            Text(
              context.l10n.goPremiumToUnlockFeature,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.homeBrown,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 18),

            SizedBox(
              height: 46,
              child: ElevatedButton(
                onPressed: () {
                  PremiumNavigation.openPaywall(
                    context,
                  );
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor:
                  AppColors.brandPrimary,
                  foregroundColor:
                  AppColors.onPrimary,
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  context.l10n.goPremium,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}