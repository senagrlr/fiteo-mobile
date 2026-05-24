import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';

class CookLoadingView extends StatelessWidget {
  const CookLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        color: Colors.white.withOpacity(0.94),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/animations/cook_loading.json',
                width: 250,
              ),

              const SizedBox(height: 28),

              const Text(
                'Creating your recipe...\nPlease wait.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.homeBrown,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}