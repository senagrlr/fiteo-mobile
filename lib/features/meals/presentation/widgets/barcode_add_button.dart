import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';

import 'package:fiteo_myapp/features/meals/domain/models/barcode_food_data.dart';
import 'package:fiteo_myapp/features/meals/presentation/screens/barcode_scanner_screen.dart';
import 'package:fiteo_myapp/features/membership/data/premium_access_service.dart';
import 'package:fiteo_myapp/features/membership/domain/premium_feature.dart';

class BarcodeAddButton extends StatelessWidget {
  final ValueChanged<BarcodeFoodData> onFoodFound;

  const BarcodeAddButton({
    super.key,
    required this.onFoodFound,
  });

  static final PremiumAccessService _premiumAccessService =
  PremiumAccessService();

  Future<void> _handleTap(BuildContext context) async {
    final canAccess = await _premiumAccessService.canAccess(
      PremiumFeature.barcodeScanner,
    );

    if (!canAccess) {
      return;
    }

    if (!context.mounted) {
      return;
    }

    await _openScanner(context);
  }

  Future<void> _openScanner(
      BuildContext context,
      ) async {
    final result =
    await Navigator.of(context)
        .push<BarcodeFoodData>(
      MaterialPageRoute(
        builder: (_) =>
        const BarcodeScannerScreen(),
      ),
    );

    if (result == null) {
      return;
    }

    onFoodFound(result);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _handleTap(context);
          },
          borderRadius:
          BorderRadius.circular(22),
          child: Ink(
            width: 170,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.surfacePrimary,
              borderRadius:
              BorderRadius.circular(22),
              border: Border.all(
                color:
                AppColors.calendarCompleted,
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.qr_code_scanner_rounded,
                  color:
                  AppColors.calendarCompleted,
                  size: 21,
                ),

                const SizedBox(width: 9),

                Text(
                  context.l10n.addWithBarcode,
                  style: AppTextStyles
                      .labelMedium
                      .copyWith(
                    color:
                    AppColors.calendarCompleted,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}