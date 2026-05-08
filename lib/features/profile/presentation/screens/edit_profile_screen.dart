import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/common/widgets/custom_button.dart';
import 'package:fiteo_myapp/common/widgets/custom_text_field.dart';
import 'package:fiteo_myapp/features/profile/data/profile_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiteo_myapp/common/utils/app_snackbar.dart';
import 'package:fiteo_myapp/features/profile/utils/profile_messages.dart';
import 'package:fiteo_myapp/common/widgets/field_error_text.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final usernameController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _profileRepository = ProfileRepository();

  bool isLoading = true;
  bool isSaving = false;
  bool isPasswordUser = false;

  String? selectedMascot;
  String? passwordError;
  String? currentPasswordError;
  String? usernameError;

  final List<String> mascots = const [
    'assets/mascots/mascot_1.png',
    'assets/mascots/mascot_2.png',
    'assets/mascots/mascot_3.png',
    'assets/mascots/mascot_4.png',
  ];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final doc = await _profileRepository.getCurrentUserDoc();
    final data = doc.data();

    final provider = data?['authProvider'] ?? '';

    usernameController.text = data?['username'] ?? '';
    selectedMascot = data?['mascot'];

    isPasswordUser = provider == 'password';

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  bool get isFormValid {
    final username = usernameController.text.trim();

    if (username.isEmpty) return false;

    if (!isPasswordUser) return true;

    final currentPassword = currentPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    final passwordFieldsEmpty =
        currentPassword.isEmpty && newPassword.isEmpty && confirmPassword.isEmpty;

    if (passwordFieldsEmpty) return true;

    return currentPassword.isNotEmpty &&
        newPassword.length >= 8 &&
        confirmPassword == newPassword;
  }

  void _showMascotSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 🔥 önemli
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.35, // 🔥 açıldığında yüksekliği
          minChildSize: 0.25,
          maxChildSize: 0.5, // yukarı çekilebilir
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 34),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Choose your mascot',
                    style: TextStyle(
                      color: AppColors.homeBrown,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          runSpacing: 18,
                          children: List.generate(mascots.length, (index) {
                            final mascot = mascots[index];
                            final isSelected = selectedMascot == mascot;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedMascot = mascot;
                                });
                                Navigator.pop(context);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 88,  // 🔥 büyüttük
                                height: 88, // 🔥 büyüttük
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.onboardingBackground,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.calendarCompleted
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    mascot,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _validateAndSave() async {
    final username = usernameController.text.trim();
    final currentPassword = currentPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    setState(() {
      passwordError = null;
      currentPasswordError = null;
      usernameError = null;
    });

    if (username.isEmpty) {
      setState(() {
        usernameError = ProfileMessages.usernameRequired;
      });
      return;
    }

    final wantsPasswordChange =
        currentPassword.isNotEmpty || newPassword.isNotEmpty || confirmPassword.isNotEmpty;

    if (isPasswordUser && wantsPasswordChange) {
      if (newPassword.length < 8) {
        setState(() {
          passwordError = ProfileMessages.passwordMinLength;
        });
        return;
      }

      if (newPassword != confirmPassword) {
        setState(() {
          passwordError = ProfileMessages.passwordsDoNotMatch;
        });
        return;
      }
    }

    setState(() {
      isSaving = true;
    });

    try {
      await _profileRepository.updateProfileInfo(
        username: username,
        mascotPath: selectedMascot,
      );

      if (isPasswordUser && wantsPasswordChange) {
        await _profileRepository.changePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        );
      }

      if (!mounted) return;

      AppSnackbar.showSuccess(context, ProfileMessages.profileUpdated);

      Navigator.pop(context, true);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
          currentPasswordError = ProfileMessages.currentPasswordIncorrect;
        } else {
          passwordError = ProfileMessages.passwordUpdateFailed;
        }
        isSaving = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      AppSnackbar.showError(context, ProfileMessages.profileUpdateFailed);
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.homeBrown,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: AppColors.homeBrown,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            screenWidth * 0.10,
            20,
            screenWidth * 0.10,
            40,
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: _showMascotSelector,
                child: Stack(
                  children: [
                    Container(
                      width: 92,
                      height: 92,
                      decoration: const BoxDecoration(
                        color: AppColors.onboardingBackground,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: selectedMascot == null
                          ? Text(
                        usernameController.text.trim().isNotEmpty
                            ? usernameController.text.trim()[0].toUpperCase()
                            : 'U',
                        style: TextStyle(
                          color: AppColors.homeBrown,
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                        ),
                      )
                          : ClipOval(
                        child: Image.asset(
                          selectedMascot!,
                          width: 92,
                          height: 92,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 4,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: AppColors.calendarCompleted,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 17,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 34),

              CustomTextField(
                hintText: 'Username',
                controller: usernameController,
                onChanged: (_) {
                  setState(() {
                    usernameError = null;
                  });
                },
                fillColor: AppColors.onboardingBackground,
              ),

              if (usernameError != null)
                FieldErrorText(message: usernameError!),

            if (isPasswordUser) ...[
              const SizedBox(height: 34),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Change Password',
                  style: TextStyle(
                    color: AppColors.homeBrown,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              CustomTextField(
                hintText: 'Current password',
                controller: currentPasswordController,
                onChanged: (_) {
                  setState(() {
                    currentPasswordError = null;
                  });
                },
                isPassword: true,
                showVisibilityToggle: false,
                fillColor: AppColors.onboardingBackground,
              ),

              if (currentPasswordError != null)
                FieldErrorText(message: currentPasswordError!),

              const SizedBox(height: 16),

              CustomTextField(
                hintText: 'New password',
                controller: newPasswordController,
                onChanged: (value) {
                  if (value.trim().length >= 8 &&
                      passwordError == ProfileMessages.passwordMinLength) {
                    setState(() {
                      passwordError = null;
                    });
                  } else {
                    setState(() {});
                  }
                },
                isPassword: true,
                fillColor: AppColors.onboardingBackground,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                hintText: 'Confirm new password',
                controller: confirmPasswordController,
                onChanged: (_) {
                  setState(() {});
                },
                isPassword: true,
                fillColor: AppColors.onboardingBackground,
              ),
            ],

              if (passwordError != null)
                FieldErrorText(message: passwordError!),

              const SizedBox(height: 36),

              CustomButton(
                text: 'Save changes',
                onPressed: isSaving ? null : _validateAndSave,
                backgroundColor: isSaving
                    ? AppColors.authButtonGreen.withOpacity(0.45)
                    : AppColors.authButtonGreen,
                textColor: Colors.white,
                height: 54,
                width: screenWidth * 0.72,
                fontSize: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}