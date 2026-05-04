import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';

class TodayCaloriesCard extends StatelessWidget {
  const TodayCaloriesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
      decoration: BoxDecoration(
        color: AppColors.homeCardBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today’s Calories',
            style: TextStyle(
              color: AppColors.homeBrown,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 10),
          Divider(color: Color(0xFFDCD9D1)),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.track_changes, color: AppColors.red, size: 20),
              SizedBox(width: 10),
              Text(
                'Goal: 1,500 kcal/day',
                style: TextStyle(
                  color: AppColors.homeBrown,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.flag, color: AppColors.red, size: 20),
              SizedBox(width: 10),
              Text(
                'Remaining: 240 kcal',
                style: TextStyle(
                  color: AppColors.homeBrown,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}