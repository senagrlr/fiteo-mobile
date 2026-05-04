import 'package:fiteo_myapp/features/meals/presentation/screens/meals_screen.dart';
import 'package:fiteo_myapp/features/profile/presentation/screens/profile_screen.dart';
import 'package:fiteo_myapp/features/workout/presentation/screens/workout_screen.dart';
import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/features/home/presentation/screens/home_screen.dart';
import 'package:fiteo_myapp/features/ai_coach/presentation/screens/ai_coach_screen.dart';


class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomeScreen(),
    MealsScreen(),
    AiCoachScreen(),
    WorkoutScreen(),
    ProfileScreen(),
  ];

  final List<IconData> icons = const [
    Icons.home_outlined,
    Icons.restaurant_menu_outlined,
    Icons.auto_awesome_outlined,
    Icons.fitness_center_outlined,
    Icons.person_outline,
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.generalBackground,
      body: pages[selectedIndex],
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.bottomNavBackground,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              icons.length,
                  (index) {
                final isSelected = selectedIndex == index;

                return GestureDetector(
                  onTap: () => onItemTapped(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    width: isSelected ? 56 : 46,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.bottomNavSelected.withOpacity(0.10)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 220),
                      scale: isSelected ? 1.18 : 1.0,
                      child: Icon(
                        icons[index],
                        size: 28,
                        color: isSelected
                            ? AppColors.bottomNavSelected
                            : AppColors.bottomNavUnselected,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}