import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fiteo_myapp/app/router/app_routes.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/common/utils/app_snackbar.dart';
import 'package:fiteo_myapp/common/widgets/custom_button.dart';
import 'package:fiteo_myapp/common/widgets/custom_text_field.dart';
import 'package:fiteo_myapp/common/widgets/field_error_text.dart';
import 'package:fiteo_myapp/common/widgets/system_navigation_bar.dart';
import 'package:fiteo_myapp/features/auth/data/auth_repository.dart';
import 'package:fiteo_myapp/features/auth/presentation/screens/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() =>
      _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordController =
  TextEditingController();

  final TextEditingController _emailController =
  TextEditingController();

  final TextEditingController _usernameController =
  TextEditingController();

  final TextEditingController _birthDateController =
  TextEditingController();

  final AuthRepository _authRepository =
  AuthRepository();

  bool _isLoading = false;

  String? emailError;
  String? _passwordError;
  String? birthDateError;

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _birthDateController.dispose();

    super.dispose();
  }

  DateTime? _parseBirthDate(String value) {
    final parts = value.split('/');

    if (parts.length != 3) {
      return null;
    }

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null ||
        month == null ||
        year == null) {
      return null;
    }

    final date = DateTime(
      year,
      month,
      day,
    );

    if (date.day != day ||
        date.month != month ||
        date.year != year) {
      return null;
    }

    return date;
  }

  Future<void> _validateAndContinue() async {
    final email =
    _emailController.text.trim();

    final username =
    _usernameController.text.trim();

    final password =
    _passwordController.text.trim();

    final birthDate =
    _birthDateController.text.trim();

    setState(() {
      emailError = null;
      _passwordError = null;
      birthDateError = null;
    });

    if (email.isEmpty ||
        username.isEmpty ||
        password.isEmpty ||
        birthDate.isEmpty) {
      AppSnackbar.showError(
        context,
        context.l10n.fillAllFields,
      );

      return;
    }

    if (password.length < 8) {
      setState(() {
        _passwordError =
            context.l10n.passwordTooShort;
      });

      return;
    }

    final parsedBirthDate =
    _parseBirthDate(birthDate);

    if (parsedBirthDate == null) {
      setState(() {
        birthDateError =
            context.l10n.invalidBirthDate;
      });

      return;
    }

    final today = DateTime.now();

    final todayOnly = DateTime(
      today.year,
      today.month,
      today.day,
    );

    if (parsedBirthDate.isAfter(todayOnly)) {
      setState(() {
        birthDateError =
            context.l10n.invalidBirthDate;
      });

      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authRepository.signUp(
        email: email,
        password: password,
        username: username,
        birthDate: birthDate,
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      Navigator.pushReplacementNamed(
        context,
        AppRoutes.verifyEmail,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (e.code == 'email-already-in-use') {
        setState(() {
          emailError =
              context.l10n.emailAlreadyRegistered;
        });
      } else if (e.code == 'invalid-email') {
        setState(() {
          emailError =
              context.l10n.invalidEmail;
        });
      } else {
        AppSnackbar.showError(
          context,
          context.l10n.somethingWentWrong,
        );
      }
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      AppSnackbar.showError(
        context,
        context.l10n.somethingWentWrong,
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
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.10,
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 70),

                Text(
                  context.l10n.signUp,
                  style: AppTextStyles
                      .displayMedium
                      .copyWith(
                    color: AppColors.authText,
                  ),
                ),

                const SizedBox(height: 8),

                RichText(
                  text: TextSpan(
                    style: AppTextStyles
                        .bodyLarge
                        .copyWith(
                      color: AppColors.authText,
                    ),
                    children: [
                      TextSpan(
                        text:
                        '${context.l10n.alreadyHaveAccount} ',
                      ),
                      TextSpan(
                        text: context.l10n.login,
                        style: AppTextStyles
                            .titleSmall
                            .copyWith(
                          color:
                          AppColors.authText,
                          fontWeight:
                          FontWeight.w800,
                        ),
                        recognizer:
                        TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                const LoginScreen(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

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

                const SizedBox(height: 16),

                CustomTextField(
                  hintText:
                  context.l10n.username,
                  controller:
                  _usernameController,
                ),

                const SizedBox(height: 16),

                CustomTextField(
                  hintText:
                  context.l10n.password,
                  isPassword: true,
                  controller:
                  _passwordController,
                  onChanged: (value) {
                    if (_passwordError != null &&
                        value.length >= 8) {
                      setState(() {
                        _passwordError = null;
                      });
                    }
                  },
                ),

                if (_passwordError != null)
                  FieldErrorText(
                    message: _passwordError!,
                  ),

                const SizedBox(height: 16),

                CustomTextField(
                  hintText:
                  context.l10n.dateOfBirth,
                  controller:
                  _birthDateController,
                  keyboardType:
                  TextInputType.number,
                  inputFormatters: [
                    BirthDateInputFormatter(),
                  ],
                  onChanged: (_) {
                    if (birthDateError != null) {
                      setState(() {
                        birthDateError = null;
                      });
                    }
                  },
                ),

                if (birthDateError != null)
                  FieldErrorText(
                    message: birthDateError!,
                  ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        color:
                        AppColors.authText,
                        thickness: 1.2,
                        endIndent: 24,
                        indent: 50,
                      ),
                    ),

                    Text(
                      context.l10n.or,
                      style: AppTextStyles
                          .bodyMedium
                          .copyWith(
                        color:
                        AppColors.authText,
                      ),
                    ),

                    const Expanded(
                      child: Divider(
                        color:
                        AppColors.authText,
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
                      final userCredential =
                      await _authRepository
                          .signInWithGoogle();

                      if (!context.mounted) {
                        return;
                      }

                      if (userCredential == null ||
                          userCredential.user ==
                              null) {
                        AppSnackbar.showError(
                          context,
                          context.l10n
                              .googleSignInFailed,
                        );

                        return;
                      }

                      final user =
                      userCredential.user!;

                      final isOnboardingCompleted =
                      await _authRepository
                          .isOnboardingCompleted(
                        user.uid,
                      );

                      if (!context.mounted) {
                        return;
                      }

                      if (isOnboardingCompleted) {
                        Navigator
                            .pushReplacementNamed(
                          context,
                          AppRoutes.main,
                        );
                      } else {
                        Navigator
                            .pushReplacementNamed(
                          context,
                          AppRoutes.planSetup,
                        );
                      }
                    } catch (_) {
                      if (!context.mounted) {
                        return;
                      }

                      AppSnackbar.showError(
                        context,
                        context.l10n
                            .googleSignInFailed,
                      );
                    }
                  },
                  child: Container(
                    width: screenWidth * 0.42,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors
                          .onboardingBackground,
                      borderRadius:
                      BorderRadius.circular(
                        28,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/google_icon.png',
                          width: 30,
                          height: 30,
                        ),

                        const SizedBox(width: 10),

                        Text(
                          'Google',
                          style: AppTextStyles
                              .bodyMedium
                              .copyWith(
                            color:
                            AppColors.authText,
                            fontWeight:
                            FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                Padding(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  child: Text(
                    context.l10n.signUpAgreement,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption
                        .copyWith(
                      color: AppColors.textMuted,
                      height: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                CustomButton(
                  text: _isLoading
                      ? context.l10n.loading
                      : context.l10n.signUp,
                  onPressed: _isLoading
                      ? null
                      : _validateAndContinue,
                  backgroundColor:
                  AppColors.authButtonGreen,
                  textColor: Colors.white,
                  height: 54,
                  width: screenWidth * 0.72,
                  fontSize: 22,
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BirthDateInputFormatter
    extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final digitsOnly = newValue.text.replaceAll(
      RegExp(r'\D'),
      '',
    );

    final buffer = StringBuffer();

    for (int i = 0;
    i < digitsOnly.length && i < 8;
    i++) {
      if (i == 2 || i == 4) {
        buffer.write('/');
      }

      buffer.write(digitsOnly[i]);
    }

    final text = buffer.toString();

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(
        offset: text.length,
      ),
    );
  }
}