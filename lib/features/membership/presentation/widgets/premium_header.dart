import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';

class PremiumHeader extends StatelessWidget {
  final VoidCallback onClose;

  const PremiumHeader({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final statusBarHeight =
        MediaQuery.paddingOf(context).top;

    return SizedBox(
      height: 220,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipPath(
            clipper: _PremiumHeaderClipper(),
            child: Container(
              width: double.infinity,
              height: 220,
              color:
              AppColors.planTrackingHeaderBackground,
            ),
          ),

          // CLOSE
          Positioned(
            top: statusBarHeight + 10,
            left: 10,
            child: SizedBox(
              width: 44,
              height: 44,
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: onClose,
                icon: const Icon(
                  Icons.close_rounded,
                  color: AppColors.onPrimary,
                  size: 28,
                  weight: 700,
                ),
              ),
            ),
          ),

          // TITLE + SUBTITLE
          Positioned(
            top: statusBarHeight + 50,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Text(
                  context.l10n.upgradeToPro,
                  textAlign: TextAlign.center,
                  style:
                  AppTextStyles.titleLarge.copyWith(
                    color: AppColors.onPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  context
                      .l10n
                      .unlockAllPremiumFeatures,
                  textAlign: TextAlign.center,
                  style:
                  AppTextStyles.bodySmall.copyWith(
                    color: AppColors.onPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumHeaderClipper
    extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(
      0,
      size.height * 0.55,
    );

    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 1.28,
      size.width,
      size.height * 0.55,
    );

    path.lineTo(
      size.width,
      0,
    );

    path.close();

    return path;
  }

  @override
  bool shouldReclip(
      covariant CustomClipper<Path> oldClipper,
      ) {
    return false;
  }
}