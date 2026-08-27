import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';

class PremiumMembershipHeader extends StatelessWidget {
  final VoidCallback onClose;

  const PremiumMembershipHeader({
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
          // ALTIN PREMIUM HEADER
          ClipPath(
            clipper: _PremiumMembershipHeaderClipper(),
            child: Container(
              width: double.infinity,
              height: 220,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColors.membershipPremiumDark,
                    AppColors.membershipPremium,
                  ],
                ),
              ),
            ),
          ),

          // X
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
                ),
              ),
            ),
          ),

          // PREMIUM + açıklama
          Positioned(
            top: statusBarHeight + 50,
            left: 24,
            right: 24,
            child: Column(
              children: [
                Text(
                  'PREMIUM',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.onPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.7,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Premium ile faydalandığın avantajlar',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySmall.copyWith(
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

class _PremiumMembershipHeaderClipper
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