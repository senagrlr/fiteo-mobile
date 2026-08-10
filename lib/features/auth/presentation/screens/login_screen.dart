import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/router/app_routes.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/common/utils/app_snackbar.dart';
import 'package:fiteo_myapp/common/widgets/custom_button.dart';
import 'package:fiteo_myapp/common/widgets/custom_text_field.dart';
import 'package:fiteo_myapp/common/widgets/field_error_text.dart';
import 'package:fiteo_myapp/features/auth/data/auth_repository.dart';
import 'package:fiteo_myapp/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:fiteo_myapp/features/auth/presentation/screens/sign_up_screen.dart';

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
        passwordError = context.l10n.emailAndPasswordEmpty;
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authRepository.login(
        email: email,
        password: password,
      );

      await _authRepository.saveUserFcmToken();

      final user = _authRepository.currentUser;
      await user?.reload();

      final refreshedUser = _authRepository.currentUser;
      final isVerified = refreshedUser?.emailVerified ?? false;

      if (!mounted) return;

      if (!isVerified) {
        setState(() => _isLoading = false);

        Navigator.pushReplacementNamed(
          context,
          AppRoutes.verifyEmail,
        );

        return;
      }

      final isOnboardingCompleted =
      await _authRepository.isOnboardingCompleted(
        refreshedUser!.uid,
      );

      if (!mounted) return;

      if (isOnboardingCompleted) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.main,
        );
      } else {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.planSetup,
        );
      }
    } on FirebaseAuthException {
      if (!mounted) return;

      setState(() {
        passwordError = context.l10n.wrongEmailOrPassword;
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
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 120),

              // LOGIN TITLE
              Text(
                context.l10n.login,
                style: AppTextStyles.displayMedium.copyWith(
                  color: AppColors.authText,
                ),
              ),

              const SizedBox(height: 38),

              // EMAIL
              CustomTextField(
                hintText: context.l10n.email,
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

              // PASSWORD
              CustomTextField(
                hintText: context.l10n.password,
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
                FieldErrorText(
                  message: passwordError!,
                ),

              const SizedBox(height: 20),

              // FORGOT PASSWORD
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: Text(
                    context.l10n.forgotPassword,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.authButtonGreen,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // OR DIVIDER
              Row(
                children: [
                  const Expanded(
                    child: Divider(
                      color: AppColors.authText,
                      thickness: 1.2,
                      endIndent: 24,
                      indent: 50,
                    ),
                  ),

                  Text(
                    context.l10n.or,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.authText,
                    ),
                  ),

                  const Expanded(
                    child: Divider(
                      color: AppColors.authText,
                      thickness: 1.2,
                      indent: 24,
                      endIndent: 50,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // GOOGLE LOGIN
              GestureDetector(
                onTap: () async {
                  try {
                    final userCredential =
                    await _authRepository.signInWithGoogle();

                    if (!context.mounted) return;

                    if (userCredential == null ||
                        userCredential.user == null) {
                      AppSnackbar.showError(
                        context,
                        context.l10n.googleSignInFailed,
                      );
                      return;
                    }

                    final user = userCredential.user!;

                    final isOnboardingCompleted =
                    await _authRepository.isOnboardingCompleted(
                      user.uid,
                    );

                    if (!context.mounted) return;

                    if (isOnboardingCompleted) {
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.main,
                      );
                    } else {
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.planSetup,
                      );
                    }
                  } catch (_) {
                    if (!context.mounted) return;

                    AppSnackbar.showError(
                      context,
                      context.l10n.googleSignInFailed,
                    );
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

                      Text(
                        'Google',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.authText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // DON'T HAVE AN ACCOUNT / SIGN UP
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.authText,
                  ),
                  children: [
                    TextSpan(
                      text:
                      '${context.l10n.dontHaveAccount} ',
                    ),
                    TextSpan(
                      text: context.l10n.signUp,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.authText,
                        fontWeight: FontWeight.w700,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const SignUpScreen(),
                            ),
                          );
                        },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // LOGIN BUTTON
              CustomButton(
                text: _isLoading
                    ? context.l10n.loading
                    : context.l10n.login,
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