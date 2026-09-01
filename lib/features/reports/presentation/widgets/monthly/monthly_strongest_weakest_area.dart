import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/features/reports/models/monthly_report_data.dart';
import 'package:fiteo_myapp/features/reports/presentation/widgets/monthly/monthly_area_detail_card.dart';

class MonthlyStrongestWeakestArea
    extends StatefulWidget {
  final MonthlyAreaData strongestArea;
  final MonthlyAreaData weakestArea;

  const MonthlyStrongestWeakestArea({
    super.key,
    required this.strongestArea,
    required this.weakestArea,
  });

  @override
  State<MonthlyStrongestWeakestArea>
  createState() =>
      _MonthlyStrongestWeakestAreaState();
}

class _MonthlyStrongestWeakestAreaState
    extends State<MonthlyStrongestWeakestArea> {
  bool showStrongest = true;

  @override
  Widget build(BuildContext context) {
    final selectedData = showStrongest
        ? widget.strongestArea
        : widget.weakestArea;

    return Column(
      children: [
        // =====================================================
        // STRONGEST / WEAKEST TABS
        // CONTAINER DIŞINDA
        // =====================================================

        Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            _AreaTab(
              width: 130,
              label:
              context.l10n.strongestArea,
              selected: showStrongest,
              onTap: () {
                setState(() {
                  showStrongest = true;
                });
              },
            ),

            const SizedBox(width: 10),

            _AreaTab(
              width: 120,
              label:
              context.l10n.weakestArea,
              selected: !showStrongest,
              onTap: () {
                setState(() {
                  showStrongest = false;
                });
              },
            ),
          ],
        ),

        const SizedBox(height: 12),

        // =====================================================
        // AREA CARD
        // =====================================================

        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(
            20,
            18,
            20,
            21,
          ),
          decoration: BoxDecoration(
            color:
            AppColors.calendarSummaryCardBackground,
            borderRadius:
            BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color:
                AppColors.calendarSummaryShadow,
                blurRadius: 14,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              AnimatedSwitcher(
                duration: const Duration(
                  milliseconds: 220,
                ),
                child:
                MonthlyAreaDetailCard(
                  key:
                  ValueKey(showStrongest),
                  data:
                  selectedData,
                  isStrongest:
                  showStrongest,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AreaTab extends StatelessWidget {
  final double width;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _AreaTab({
    required this.width,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior:
      HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration:
        const Duration(
          milliseconds: 180,
        ),
        width: width,
        height: 35,
        alignment:
        Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? AppColors.authButtonGreen
              : Colors.transparent,
          borderRadius:
          BorderRadius.circular(20),
        ),
        child: Text(
          label,
          maxLines: 1,
          style:
          AppTextStyles.labelSmall.copyWith(
            color: selected
                ? AppColors.onPrimary
                : AppColors
                .planTrackingSecondaryLabel,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}