import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  // ============================================================
  // BASE PALETTE
  // Aynı HEX değerini birden fazla kez yazmamak için.
  // Bu değişkenler private'dır; UI dosyalarında doğrudan kullanılmaz.
  // ============================================================

  static const Color _white = Color(0xFFFFFFFF);
  static const Color _black = Color(0xFF000000);

  static const Color _legacyPrimary = Color(0xFF6C63FF);
  static const Color _textPrimary = Color(0xFF111111);
  static const Color _textSecondary = Color(0xFF666666);
  static const Color _border = Color(0xFFE0E0E0);

  static const Color _brandGreen = Color(0xFFACBB5E);
  static const Color _authGreen = Color(0xFFAFBE57);

  static const Color _brandBrown = Color(0xFF693C37);
  static const Color _darkBrown = Color(0xFF74433E);
  static const Color _softBrown = Color(0xFF9B7775);

  static const Color _mutedBrown = Color(0xFFA89A97);
  static const Color _secondaryBrown = Color(0xFF8F6C69);
  static const Color _secondaryTextBrown = Color(0xFF8C7772);

  static const Color _errorRed = Color(0xFFC43D3F);

  static const Color _surfaceSoft = Color(0xFFF4F4EF);
  static const Color _surfaceWarm = Color(0xFFF5F4F0);
  static const Color _surfaceBubble = Color(0xFFF3F1EC);
  static const Color _calendarSurface = Color(0xFFF6F6F6);

  static const Color _fieldDivider = Color(0xFFDCD9D1);

  static const Color _lightMutedGrey = Color(0xFFB0ADAD);

  static const Color _lightGreen = Color(0xFFCAD499);

  static const Color _waterBlue = Color(0xFF9CC4F2);

  // ============================================================
  // LEGACY / GENERAL
  // Mevcut kullanımları bozmamak için isimler korunuyor.
  // ============================================================

  static const Color primary = _legacyPrimary;
  static const Color background = _white;
  static const Color textPrimary = _textPrimary;
  static const Color textSecondary = _textSecondary;
  static const Color border = _border;

  // ============================================================
  // CORE SEMANTIC COLORS
  // ============================================================

  static const Color brandPrimary = _brandGreen;
  static const Color brandAccent = _brandBrown;

  static const Color textBrand = _brandBrown;
  static const Color textBrandSoft = _softBrown;
  static const Color textMuted = _mutedBrown;

  static const Color surfacePrimary = _white;
  static const Color surfaceSoft = _surfaceSoft;

  static const Color onPrimary = _white;

  static const Color error = _errorRed;
  static const Color success = _brandGreen;

  // ============================================================
  // ONBOARDING
  // ============================================================

  static const Color onboardingBackground = Color(0xFFECEBE2);
  static const Color onboardingText = _softBrown;
  static const Color onboardingDotInactive = Color(0xFFA37A7A);
  static const Color onboardingDotActive = _brandBrown;

  // ============================================================
  // AUTH
  // ============================================================

  static const Color authFieldBackground = _fieldDivider;
  static const Color authText = _softBrown;
  static const Color authButtonGreen = _authGreen;
  static const Color authBlackText = Color(0xFF3A312F);
  static const Color lineRed = Color(0xFFB76F6F);
  static const Color bar = Color(0xFFEDEFD4);

  // ============================================================
  // GENERAL / HOME
  // ============================================================

  static const Color generalBackground = _white;
  static const Color homeCardBackground = _surfaceSoft;
  static const Color homeBrown = _brandBrown;
  static const Color blackText = _black;
  static const Color red = _errorRed;
  static const Color mealIconBrown = _secondaryBrown;
  static const Color homeMutedText = _lightMutedGrey;
  static const Color homeSecondaryValue = Color(0xFF737373);

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  static const Color bottomNavBackground = Color(0xFFF7F8F0);
  static const Color bottomNavSelected = _brandBrown;
  static const Color bottomNavUnselected = Color(0xFFCCC8A7);
  static const Color bottomNavShadow = Color(0x0F000000);

  // ============================================================
  // CALORIE APPLE PROGRESS
  // ============================================================

  static const Color appleProgress = _brandGreen;
  static const Color appleProgressBackground = Color(0xFFDDE1CE);
  static const Color appleStem = _darkBrown;
  static const Color appleOverGoal = Color(0xFFD85B55);
  static const Color appleOverGoalGlow = Color(0x33D85B55);
  static const Color calorieText = _darkBrown;

  // ============================================================
  // DAILY MACROS
  // ============================================================

  static const Color dailyGoalCardBackground = _surfaceWarm;
  static const Color dailyGoalText = _darkBrown;
  static const Color proteinProgress = Color(0xFF99AD38);
  static const Color fatProgress = Color(0xFFA8A883);
  static const Color carbsProgress = _lightGreen;
  static const Color macroProgressBackground = Color(0xFFE3E4D8);

  // ============================================================
  // BOTTOM SHEET
  // ============================================================

  static const Color bottomSheetBackground = Color(0xFFFFFEFB);
  static const Color bottomSheetHandle = Color(0xFFD8D4CC);
  static const Color bottomSheetSecondaryText = _secondaryTextBrown;

  // ============================================================
  // WATER DIALOG
  // ============================================================

  static const Color waterDialogBackground = Color(0xFFF1F0E9);
  static const Color waterDialogText = _darkBrown;
  static const Color waterDialogSecondaryText = _secondaryTextBrown;
  static const Color waterDialogInputBackground = _white;
  static const Color waterGlassBackground = Color(0xFFEAF5FF);
  static const Color waterGlassFill = _waterBlue;
  static const Color waterGlassTop = Color(0xFFD3E8FC);
  static const Color waterGlassOutline = Color(0xFFF4FAFF);
  static const Color waterGlassHandle = Color(0xFF8FA8C3);
  static const Color waterDrinkButton = Color(0xFF9AC6F5);
  static const Color waterDrinkButtonDisabled = Color(0xFFD4DCE3);
  static const Color waterEditIcon = _secondaryBrown;

  // ============================================================
  // WATER CARD
  // ============================================================

  static const Color waterCardInactiveText = _lightMutedGrey;
  static const Color waterCardBackground = _surfaceWarm;
  static const Color waterCardTitle = _darkBrown;
  static const Color waterAddButton = Color(0xFFCFE5FA);
  static const Color waterWaveLight = Color(0xFFB4D8FA);
  static const Color waterWaveDark = Color(0xFF94C5F7);

  // ============================================================
  // MONTHLY CALENDAR
  // ============================================================

  static const Color calendarInactive = _calendarSurface;
  static const Color calendarCompleted = _brandGreen;
  static const Color calendarBackground = _calendarSurface;
  static const Color calendarArrow = Color(0xFFB8BEC4);
  static const Color calendarWeekdayText = Color(0xFFA9A0A0);

  // ============================================================
  // MONTHLY CALENDAR SUMMARY CARD
  // ============================================================

  static const Color calendarSummaryCardBackground = Color(0xFFFFFDFC);
  static const Color calendarSummaryShadow = Color(0x14000000);
  static const Color calendarSummaryTitle = _darkBrown;
  static const Color calendarSummaryLabel = _mutedBrown;
  static const Color calendarSummaryValue = _darkBrown;
  static const Color calendarFoodIcon = Color(0xFFC98E87);
  static const Color calendarBurnIcon = Color(0xFFA7B68B);
  static const Color calendarGoalIcon = Color(0xFFE88178);
  static const Color calendarWaterIcon = _waterBlue;
  static const Color calendarMacroTrack = Color(0xFFE8E3DB);

  // ============================================================
  // ALLERGENS / AI
  // ============================================================

  static const Color allergenCardBackground = Color(0xFFF7F6F4);
  static const Color allergenCardBorder = Color(0xFFEAE5DF);
  static const Color allergenChipBorder = Color(0xFFE5E1DC);
  static const Color aiCookModeSwitch = Color(0xFF6F7F32);

  // ============================================================
  // CALORIE DONUT
  // ============================================================

  static const Color donutEmptyTrack = Color(0xFFC9C6C6);

  // ============================================================
  // MEALS / FOOD
  // ============================================================

  static const Color mealFieldDivider = _fieldDivider;
  static const Color deleteFoodBackground = Color(0xFFFFEEEE);
  static const Color deleteFoodForeground = Color(0xFFB94A48);

  // ============================================================
  // PLAN SETUP
  // ============================================================

  static const Color planGenericLine = Color(0xFFD5D7D0);
  static const Color confettiLightGreen = _lightGreen;
  static const Color confettiGold = Color(0xFFFFD98E);

  // ============================================================
  // SPEECH / RECIPE CARDS
  // ============================================================

  static const Color speechBubbleBackground = _surfaceBubble;
  static const Color savedRecipeCaloriesBackground = _surfaceBubble;

  // ============================================================
  // WEEKLY CHART
  // ============================================================

  static const Color weeklyChartDivider = Color(0xFFE1DED6);
  static const Color weeklyChartGridLine = Color(0xFFE7E3EE);
}