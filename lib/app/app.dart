import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_theme.dart';
import 'package:fiteo_myapp/features/onboarding/presentation/screens/onboarding_screen.dart';

class FiteoApp extends StatelessWidget {
  const FiteoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fiteo',
      theme: AppTheme.lightTheme,
      home: const OnboardingScreen(),
    );
  }
}