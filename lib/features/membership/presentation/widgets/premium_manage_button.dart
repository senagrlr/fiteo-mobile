import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';

class PremiumManageButton
    extends StatelessWidget {
  final VoidCallback? onTap;

  const PremiumManageButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height:
      52,
      child: Material(
        color:
        Colors.transparent,
        child: InkWell(
          onTap:
          onTap,
          borderRadius:
          BorderRadius.circular(
            28,
          ),
          child: Ink(
            decoration:
            BoxDecoration(
              gradient:
              const LinearGradient(
                begin:
                Alignment.centerLeft,
                end:
                Alignment.centerRight,
                colors: [
                  AppColors
                      .membershipPremiumDark,
                  AppColors
                      .membershipPremium,
                ],
              ),
              borderRadius:
              BorderRadius.circular(
                28,
              ),
            ),
            child: Center(
              child: Text(
                'Aboneliği Yönet',
                style:
                AppTextStyles.bodyMedium.copyWith(
                  color:
                  AppColors.onPrimary,
                  fontSize:
                  16,
                  fontWeight:
                  FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}