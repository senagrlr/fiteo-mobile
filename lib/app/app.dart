import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fiteo_myapp/app/theme/app_theme.dart';

import 'package:fiteo_myapp/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:fiteo_myapp/features/auth/presentation/screens/login_screen.dart';
import 'package:fiteo_myapp/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:fiteo_myapp/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:fiteo_myapp/features/auth/presentation/screens/verify_email_screen.dart';

import 'package:fiteo_myapp/features/plan_setup/presentation/screens/plan_setup_flow_screen.dart';
import 'package:fiteo_myapp/features/main/presentation/screens/main_navigation_screen.dart';

class FiteoApp extends StatelessWidget {
  const FiteoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fiteo',
        theme: AppTheme.lightTheme,
        initialRoute: '/onboarding',
        routes: {
          '/onboarding': (context) => const OnboardingScreen(),

          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/forgot-password': (context) => const ForgotPasswordScreen(),
          '/verify-email': (context) => const VerifyEmailScreen(),

          '/plan-setup': (context) => const PlanSetupFlowScreen(),

          '/main': (context) => const MainNavigationScreen(),
        },
      ),
    );
  }
}