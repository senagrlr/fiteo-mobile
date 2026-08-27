import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/membership_badge.dart';

class ProfileHeader extends StatelessWidget {
  final String username;
  final String email;
  final String? mascot;
  final bool isPremium;
  final VoidCallback? onMembershipTap;

  const ProfileHeader({
    super.key,
    required this.username,
    required this.email,
    this.mascot,
    this.isPremium = false,
    this.onMembershipTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 235,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -45,
            left: -35,
            right: -55,
            child: Image.asset(
              'assets/images/profile_header_bg.png',
              width: MediaQuery.of(context).size.width + 70,
              height: 270,
              fit: BoxFit.fill,
            ),
          ),

          Positioned(
            top: 68,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: const BoxDecoration(
                    color: AppColors.surfacePrimary,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: mascot == null
                      ? Text(
                    username.isNotEmpty
                        ? username[0].toUpperCase()
                        : 'U',
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.homeBrown,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  )
                      : ClipOval(
                    child: Image.asset(
                      mascot!,
                      width: 68,
                      height: 68,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  username,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.homeSecondaryValue,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                Text(
                  email,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.homeBrown,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: 45,
            right: 24,
            child: MembershipBadge(
              label: isPremium ? 'PREMIUM' : 'FREE',
              onTap: onMembershipTap,
            ),
          ),
        ],
      ),
    );
  }
}