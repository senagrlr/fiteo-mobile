import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/common/widgets/custom_button.dart';
import 'package:fiteo_myapp/common/widgets/custom_text_field.dart';
import 'package:fiteo_myapp/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:fiteo_myapp/features/auth/presentation/screens/forgot_password_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
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

              const CustomTextField(hintText: 'Mail'),
              const SizedBox(height: 16),

              const CustomTextField(
                hintText: 'Password',
                isPassword: true,
              ),

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

              Container(
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
                text: 'Login',
                onPressed: () {},
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