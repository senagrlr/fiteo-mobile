import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  final String username;
  final String email;

  const ProfileHeader({
    super.key,
    required this.username,
    required this.email,
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
            top: -55,
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
            top: 48,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'U',
                    style: TextStyle(
                      color: AppColors.homeBrown,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  username,
                  style: const TextStyle(
                    color: AppColors.homeBrown,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  email,
                  style: const TextStyle(
                    color: AppColors.homeBrown,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
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