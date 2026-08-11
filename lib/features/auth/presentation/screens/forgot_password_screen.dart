import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/router/app_routes.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/common/utils/app_snackbar.dart';
import 'package:fiteo_myapp/common/widgets/common_app_bar.dart';
import 'package:fiteo_myapp/common/widgets/custom_button.dart';
import 'package:fiteo_myapp/common/widgets/custom_text_field.dart';
import 'package:fiteo_myapp/common/widgets/field_error_text.dart';
import 'package:fiteo_myapp/common/widgets/system_navigation_bar.dart';
import 'package:fiteo_myapp/features/auth/data/auth_repository.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController =
  TextEditingController();

  final AuthRepository _authRepository =
  AuthRepository();

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
        emailError = context.l10n.enterEmail;
      });

      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authRepository.sendPasswordResetEmail(
        email: email,
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      AppSnackbar.showInfo(
        context,
        context.l10n.resetLinkSent,
      );

      Navigator.pushReplacementNamed(
        context,
        AppRoutes.login,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      final message = e.code == 'invalid-email'
          ? context.l10n.invalidEmail
          : context.l10n.resetLinkCouldNotSend;

      AppSnackbar.showError(
        context,
        message,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.of(context).size.width;

    return SystemNavigationBar(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CommonAppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.10,
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 120),

                Text(
                  context.l10n.forgotPasswordTitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.displayMedium.copyWith(
                    color: AppColors.authText,
                  ),
                ),

                const SizedBox(height: 30),

                CustomTextField(
                  hintText: context.l10n.email,
                  controller: _emailController,
                  onChanged: (_) {
                    if (emailError != null) {
                      setState(() {
                        emailError = null;
                      });
                    }
                  },
                ),

                if (emailError != null)
                  FieldErrorText(
                    message: emailError!,
                  ),

                const SizedBox(height: 50),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Text(
                    context.l10n.forgotPasswordDescription,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                CustomButton(
                  text: _isLoading
                      ? context.l10n.sending
                      : context.l10n.sendLink,
                  onPressed:
                  _isLoading ? null : _sendResetLink,
                  backgroundColor:
                  AppColors.authButtonGreen,
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
      ),
    );
  }
}