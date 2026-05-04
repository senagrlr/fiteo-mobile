import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';

class ProfileDropdownField extends StatelessWidget {
  final String? value;
  final List<String> items;
  final IconData icon;
  final ValueChanged<String?> onChanged;

  const ProfileDropdownField({
    super.key,
    required this.value,
    required this.items,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.homeBrown, size: 21),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                dropdownColor: Colors.white,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.homeBrown,
                ),
                style: const TextStyle(
                  color: AppColors.homeBrown,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                items: items.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}