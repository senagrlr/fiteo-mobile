import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/common/widgets/custom_button.dart';
import 'package:fiteo_myapp/common/widgets/custom_text_field.dart';

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

  String? selectedMascot;
  String? passwordError;

  final List<String> mascots = const [
    'assets/mascots/mascot_1.png',
    'assets/mascots/mascot_2.png',
    'assets/mascots/mascot_3.png',
    'assets/mascots/mascot_4.png',
  ];

  bool get isFormValid {
    final username = usernameController.text.trim();
    final currentPassword = currentPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    return username.isNotEmpty &&
        currentPassword.isNotEmpty &&
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

  void _validateAndSave() {
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    setState(() {
      if (newPassword.length < 8) {
        passwordError = 'Password must be at least 8 characters.';
      } else if (newPassword != confirmPassword) {
        passwordError = 'Passwords do not match.';
      } else {
        passwordError = null;
      }
    });

    if (!isFormValid || passwordError != null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully.'),
        backgroundColor: AppColors.authButtonGreen,
      ),
    );
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
                          ? const Text(
                        'U',
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
                onChanged: (_) => setState(() {}),
                fillColor: AppColors.onboardingBackground,
              ),

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
                onChanged: (_) => setState(() {}),
                isPassword: true,
                showVisibilityToggle: false,
                fillColor: AppColors.onboardingBackground,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                hintText: 'New password',
                controller: newPasswordController,
                onChanged: (_) => setState(() {}),
                isPassword: true,
                fillColor: AppColors.onboardingBackground,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                hintText: 'Confirm new password',
                controller: confirmPasswordController,
                onChanged: (_) => setState(() {}),
                isPassword: true,
                fillColor: AppColors.onboardingBackground,
              ),

              if (passwordError != null) ...[
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    passwordError!,
                    style: const TextStyle(
                      color: AppColors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 36),

              CustomButton(
                text: 'Save changes',
                onPressed: isFormValid ? _validateAndSave : null,
                backgroundColor: isFormValid
                    ? AppColors.authButtonGreen
                    : AppColors.authButtonGreen.withOpacity(0.45),
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