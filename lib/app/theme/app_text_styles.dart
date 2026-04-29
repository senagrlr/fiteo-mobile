import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  const AppTextStyles._();

  static TextStyle onboardingTitle(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GoogleFonts.poppins(
      fontSize: screenWidth * 0.055,
      fontWeight: FontWeight.w600,
      color: AppColors.onboardingText,
      height: 1.3,
    );
  }

  static TextStyle onboardingHeader(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GoogleFonts.poppins(
      fontSize: screenWidth * 0.075,
      fontWeight: FontWeight.w700,
      color: AppColors.onboardingText,
      height: 1.2,
    );
  }
}