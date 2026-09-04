import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';

class ProfileDropdownField extends StatelessWidget {
  final String? value;
  final List<String> items;
  final IconData icon;
  final ValueChanged<String?> onChanged;

  final bool isLocked;
  final VoidCallback? onLockedTap;

  const ProfileDropdownField({
    super.key,
    required this.value,
    required this.items,
    required this.icon,
    required this.onChanged,
    this.isLocked = false,
    this.onLockedTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLocked) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onLockedTap,
          borderRadius:
          BorderRadius.circular(24),
          child: Ink(
            height: 52,
            padding:
            const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: AppColors.homeBrown,
                  size: 21,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    value ?? '',
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    style: AppTextStyles
                        .bodyMedium
                        .copyWith(
                      color: AppColors
                          .homeSecondaryValue,
                      fontSize: 15,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                const Icon(
                  Icons.lock_outline_rounded,
                  color: AppColors
                      .homeSecondaryValue,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.homeBrown,
            size: 21,
          ),

          const SizedBox(width: 12),

          Expanded(
            child:
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                dropdownColor:
                Colors.white,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors
                      .homeSecondaryValue,
                  size: 24,
                ),
                style: AppTextStyles
                    .bodyMedium
                    .copyWith(
                  color: AppColors
                      .homeSecondaryValue,
                  fontSize: 15,
                  fontWeight:
                  FontWeight.w600,
                ),
                items: items.map(
                      (item) {
                    return DropdownMenuItem<
                        String>(
                      value: item,
                      child: Text(
                        item,
                        style:
                        AppTextStyles
                            .bodyMedium
                            .copyWith(
                          color: AppColors
                              .homeSecondaryValue,
                          fontSize: 15,
                          fontWeight:
                          FontWeight
                              .w600,
                        ),
                      ),
                    );
                  },
                ).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}