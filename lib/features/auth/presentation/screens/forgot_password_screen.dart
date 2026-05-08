import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/router/app_routes.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/common/widgets/common_app_bar.dart';
import 'package:fiteo_myapp/common/widgets/custom_button.dart';
import 'package:fiteo_myapp/common/widgets/custom_text_field.dart';
import 'package:fiteo_myapp/features/auth/data/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiteo_myapp/features/auth/utils/auth_messages.dart';
import 'package:fiteo_myapp/common/utils/app_snackbar.dart';
import 'package:fiteo_myapp/common/widgets/field_error_text.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final AuthRepository _authRepository = AuthRepository();

  bool _isLoading = false;
  String? emailError;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    final email = _emailController.text.trim();

    setState(() {
      emailError = null;
    });

    if (email.isEmpty) {
      setState(() {
        emailError = AuthMessages.enterEmail;
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authRepository.sendPasswordResetEmail(email: email);

      if (!mounted) return;

      setState(() => _isLoading = false);

      AppSnackbar.showInfo(context, AuthMessages.resetLinkSent);

      Navigator.pushReplacementNamed(context, AppRoutes.login);

    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);

      final message = e.code == 'invalid-email'
          ? AuthMessages.invalidEmail
          : AuthMessages.resetLinkCouldNotSend;

      AppSnackbar.showError(context, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,

      // ✅ COMMON APP BAR
      appBar: const CommonAppBar(),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 120),

              const Text(
                'Forgot password?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  color: AppColors.authText,
                ),
              ),

              const SizedBox(height: 30),

              CustomTextField(
                hintText: 'Mail',
                controller: _emailController,
                onChanged: (_) {
                  setState(() {
                    emailError = null;
                  });
                },
              ),

              if (emailError != null)
                FieldErrorText(message: emailError!),

              const SizedBox(height: 50),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Enter your email address and we’ll send you a link to reset your password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF5E4A4A),
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              CustomButton(
                text: _isLoading ? 'Sending...' : 'Send link',
                onPressed: _isLoading ? null : _sendResetLink,
                backgroundColor: AppColors.authButtonGreen,
                textColor: Colors.white,
                height: 54,
                width: screenWidth * 0.65,
                fontSize: 20,
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}