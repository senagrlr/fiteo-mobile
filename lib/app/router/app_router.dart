import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/router/app_routes.dart';
import 'package:fiteo_myapp/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:fiteo_myapp/features/auth/presentation/screens/login_screen.dart';
import 'package:fiteo_myapp/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:fiteo_myapp/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:fiteo_myapp/features/auth/presentation/screens/verify_email_screen.dart';
import 'package:fiteo_myapp/features/plan_setup/presentation/screens/plan_setup_flow_screen.dart';
import 'package:fiteo_myapp/features/main/presentation/screens/main_navigation_screen.dart';
import 'package:fiteo_myapp/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:fiteo_myapp/features/profile/presentation/screens/goals_preferences_screen.dart';
import 'package:fiteo_myapp/features/profile/presentation/screens/delete_account_screen.dart';
import 'package:fiteo_myapp/features/home/presentation/screens/monthly_calendar_screen.dart';

class AppRouter {
  static Map<String, WidgetBuilder> routes = {
    AppRoutes.onboarding: (context) => const OnboardingScreen(),
    AppRoutes.login: (context) => const LoginScreen(),
    AppRoutes.signup: (context) => const SignUpScreen(),
    AppRoutes.forgotPassword: (context) => const ForgotPasswordScreen(),
    AppRoutes.verifyEmail: (context) => const VerifyEmailScreen(),
    AppRoutes.planSetup: (context) => const PlanSetupFlowScreen(),
    AppRoutes.main: (context) => const MainNavigationScreen(),
    AppRoutes.editProfile: (context) => const EditProfileScreen(),
    AppRoutes.goalsPreferences: (context) => const GoalsPreferencesScreen(),
    AppRoutes.deleteAccount: (context) => const DeleteAccountScreen(),
    AppRoutes.monthlyCalendar: (context) => const MonthlyCalendarScreen(),
  };
}