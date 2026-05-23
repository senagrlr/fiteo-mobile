import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/router/app_routes.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/common/widgets/custom_button.dart';
import 'package:fiteo_myapp/common/widgets/custom_text_field.dart';
import 'package:fiteo_myapp/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:fiteo_myapp/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:fiteo_myapp/features/auth/data/auth_repository.dart';
import 'package:fiteo_myapp/features/auth/utils/auth_messages.dart';
import 'package:fiteo_myapp/common/utils/app_snackbar.dart';
import 'package:fiteo_myapp/common/widgets/field_error_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthRepository _authRepository = AuthRepository();

  bool _isLoading = false;
  String? passwordError;

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      passwordError = null;
    });

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        passwordError = AuthMessages.emailAndPasswordEmpty;
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authRepository.login(
        email: email,
        password: password,
      );

      final user = _authRepository.currentUser;
      await user?.reload();

      final refreshedUser = _authRepository.currentUser;
      final isVerified = refreshedUser?.emailVerified ?? false;

      if (!mounted) return;

      if (!isVerified) {
        setState(() => _isLoading = false);
        Navigator.pushReplacementNamed(context, AppRoutes.verifyEmail);
        return;
      }

      final isOnboardingCompleted =
      await _authRepository.isOnboardingCompleted(refreshedUser!.uid);

      if (!mounted) return;

      if (isOnboardingCompleted) {
        Navigator.pushReplacementNamed(context, AppRoutes.main);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.planSetup);
      }

    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        passwordError = AuthMessages.wrongEmailOrPassword;
      });
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 120),

              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  color: AppColors.authText,
                ),
              ),

              const SizedBox(height: 38),

              CustomTextField(
                hintText: 'Mail',
                controller: _emailController,
                onChanged: (_) {
                  if (passwordError != null) {
                    setState(() {
                      passwordError = null;
                    });
                  }
                },
              ),

              const SizedBox(height: 16),

              CustomTextField(
                hintText: 'Password',
                isPassword: true,
                controller: _passwordController,
                onChanged: (_) {
                  if (passwordError != null) {
                    setState(() {
                      passwordError = null;
                    });
                  }
                },
              ),

              if (passwordError != null)
                FieldErrorText(message: passwordError!),

              const SizedBox(height: 20),

              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.authText,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Row(
                children: const [
                  Expanded(
                    child: Divider(
                      color: AppColors.authText,
                      thickness: 1.2,
                      endIndent: 24,
                      indent: 50,
                    ),
                  ),
                  Text(
                    'or',
                    style: TextStyle(
                      color: AppColors.authText,
                      fontSize: 16,
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: AppColors.authText,
                      thickness: 1.2,
                      indent: 24,
                      endIndent: 50,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              GestureDetector(
                  onTap: () async {
                    try {
                      final userCredential = await _authRepository.signInWithGoogle();

                      if (!context.mounted) return;

                      if (userCredential == null) {
                        AppSnackbar.showError(context, AuthMessages.googleSignInFailed);
                        return;
                      }

                      final user = userCredential.user;

                      if (user == null) {
                        AppSnackbar.showError(context, AuthMessages.googleSignInFailed);
                        return;
                      }

                      final isOnboardingCompleted =
                      await _authRepository.isOnboardingCompleted(user.uid);

                      if (!context.mounted) return;

                      if (isOnboardingCompleted) {
                        Navigator.pushReplacementNamed(context, AppRoutes.main);
                      } else {
                        Navigator.pushReplacementNamed(context, AppRoutes.planSetup);
                      }
                    } catch (e) {
                      if (!context.mounted) return;

                      AppSnackbar.showError(context, AuthMessages.googleSignInFailed);
                    }
                  },

                child: Container(
                  width: screenWidth * 0.42,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.onboardingBackground,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/google_icon.png',
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Google',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.authText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 34),

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 18,
                    color: AppColors.authText,
                  ),
                  children: [
                    const TextSpan(text: 'Don’t have an account? '),
                    TextSpan(
                      text: 'Sign up',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.authText,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignUpScreen(),
                            ),
                          );
                        },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              CustomButton(
                text: _isLoading ? 'Loading...' : 'Login',
                onPressed: _isLoading ? null : _login,
                backgroundColor: AppColors.authButtonGreen,
                textColor: Colors.white,
                height: 54,
                width: screenWidth * 0.62,
                fontSize: 22,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}