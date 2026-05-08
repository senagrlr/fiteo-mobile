import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';

class TodayCaloriesCard extends StatelessWidget {
  final int? calorieGoal;
  final int? remaining;

  const TodayCaloriesCard({
    super.key,
    required this.calorieGoal,
    required this.remaining,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
      decoration: BoxDecoration(
        color: AppColors.homeCardBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
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
                'Goal: ${calorieGoal ?? '-'} kcal/day',
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
                remaining == null
                    ? 'Remaining: -'
                    : remaining! >= 0
                    ? 'Remaining: ${remaining} kcal'
                    : 'Exceeded: ${remaining!.abs()} kcal',
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