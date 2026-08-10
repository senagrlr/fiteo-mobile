import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Fiteo's semantic typography system.
///
/// Use styles by meaning (heading, body, label), not by screen name. This keeps
/// typography consistent and allows app-wide changes from one place.
class AppTextStyles {
  const AppTextStyles._();

  static TextStyle _poppins({
    required double size,
    required FontWeight weight,
    Color color = AppColors.textPrimary,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.poppins(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  // Display — hero values and very prominent screen copy.
  static TextStyle get displayLarge => _poppins(
    size: 38,
    weight: FontWeight.w700,
    color: AppColors.textBrand,
    height: 1.12,
  );

  static TextStyle get displayMedium => _poppins(
    size: 34,
    weight: FontWeight.w600,
    color: AppColors.textBrand,
    height: 1.15,
  );

  // Headings — screen and section hierarchy.
  static TextStyle get headingLarge => _poppins(
    size: 30,
    weight: FontWeight.w700,
    color: AppColors.textBrand,
    height: 1.20,
  );

  static TextStyle get headingMedium => _poppins(
    size: 22,
    weight: FontWeight.w700,
    color: AppColors.textBrand,
    height: 1.25,
  );

  static TextStyle get headingSmall => _poppins(
    size: 20,
    weight: FontWeight.w700,
    color: AppColors.textBrand,
    height: 1.25,
  );

  // Titles — cards, bottom sheets, dialogs and prominent list rows.
  static TextStyle get titleLarge => _poppins(
    size: 18,
    weight: FontWeight.w800,
    color: AppColors.textBrand,
    height: 1.30,
  );

  static TextStyle get titleMedium => _poppins(
    size: 16,
    weight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.35,
  );

  static TextStyle get titleSmall => _poppins(
    size: 15,
    weight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.35,
  );

  // Body — readable content and supporting descriptions.
  static TextStyle get bodyLarge => _poppins(
    size: 16,
    weight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.50,
  );

  static TextStyle get bodyMedium => _poppins(
    size: 14,
    weight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.50,
  );

  static TextStyle get bodySmall => _poppins(
    size: 13,
    weight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.45,
  );

  // Labels — buttons, form labels, compact values and navigation.
  static TextStyle get labelLarge => _poppins(
    size: 18,
    weight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.30,
  );

  static TextStyle get labelMedium => _poppins(
    size: 15,
    weight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.30,
  );

  static TextStyle get labelSmall => _poppins(
    size: 12,
    weight: FontWeight.w600,
    color: AppColors.textSecondary,
    height: 1.30,
  );

  static TextStyle get caption => _poppins(
    size: 10,
    weight: FontWeight.w600,
    color: AppColors.textMuted,
    height: 1.30,
  );

  static TextStyle get input => _poppins(
    size: 18,
    weight: FontWeight.w400,
    color: AppColors.textBrandSoft,
    height: 1.30,
  );

  static TextStyle get button => _poppins(
    size: 18,
    weight: FontWeight.w700,
    color: AppColors.onPrimary,
    height: 1.20,
  );

  static TextStyle get error => _poppins(
    size: 12,
    weight: FontWeight.w500,
    color: AppColors.error,
    height: 1.35,
  );

  // Onboarding intentionally remains responsive because its copy is part of
  // the illustration composition and already relies on screen width.
  static TextStyle onboardingTitle(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return _poppins(
      size: screenWidth * 0.055,
      weight: FontWeight.w600,
      color: AppColors.onboardingText,
      height: 1.30,
    );
  }

  static TextStyle onboardingHeader(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return _poppins(
      size: screenWidth * 0.075,
      weight: FontWeight.w700,
      color: AppColors.onboardingText,
      height: 1.20,
    );
  }

  /// Material text theme for widgets that consume Theme.of(context).textTheme.
  static TextTheme get textTheme => TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    headlineLarge: headingLarge,
    headlineMedium: headingMedium,
    headlineSmall: headingSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );
}
