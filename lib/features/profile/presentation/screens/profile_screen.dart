import 'package:flutter/material.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/profile_header.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/profile_menu_item.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/weekly_views_card.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:fiteo_myapp/features/profile/presentation/screens/goals_preferences_screen.dart';
import 'package:fiteo_myapp/features/profile/presentation/screens/delete_account_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 50),
        child: Column(
          children: [
            const ProfileHeader(
              username: 'Username',
              email: 'user@gmail.com',
            ),

            const SizedBox(height: 14),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 22),
              child: WeeklyViewsCard(),
            ),

            const SizedBox(height: 50),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 42),
              child: Column(
                children: [
                  ProfileMenuItem(
                    icon: Icons.edit,
                    title: 'Edit Profile',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditProfileScreen(),
                        ),
                      );
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.track_changes,
                    title: 'Goals & Preferences',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GoalsPreferencesScreen(),
                        ),
                      );
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.logout,
                    title: 'Log out',
                    onTap: () {},
                  ),
                  ProfileMenuItem(
                    icon: Icons.delete_outline,
                    title: 'Delete my account',
                    color: AppColors.red,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DeleteAccountScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}