import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:intl/intl.dart';

class HomeHeader extends StatelessWidget {
  final int streakDays;

  const HomeHeader({
    super.key,
    required this.streakDays,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DateFormat('d MMMM', 'en_US').format(today), // 🔥 İngilizce tarih
          style: const TextStyle(
            color: AppColors.homeBrown,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.homeCardBackground,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.local_fire_department,
                color: AppColors.red,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                '$streakDays days',
                style: const TextStyle(
                  color: AppColors.homeBrown,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}