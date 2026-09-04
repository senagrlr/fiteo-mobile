import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';

import 'package:fiteo_myapp/features/meals/domain/models/barcode_food_data.dart';
import 'package:fiteo_myapp/features/meals/presentation/screens/barcode_scanner_screen.dart';

import 'package:fiteo_myapp/features/membership/data/premium_access_service.dart';
import 'package:fiteo_myapp/features/membership/domain/premium_feature.dart';
import 'package:fiteo_myapp/features/membership/presentation/premium_navigation.dart';

class BarcodeAddButton extends StatelessWidget {
  final ValueChanged<BarcodeFoodData> onFoodFound;

  const BarcodeAddButton({
    super.key,
    required this.onFoodFound,
  });

  static final PremiumAccessService _premiumAccessService =
  PremiumAccessService();

  Future<void> _handleTap(
      BuildContext context,
      ) async {
    final canAccess =
    await _premiumAccessService.canAccess(
      PremiumFeature.barcodeScanner,
    );

    if (!context.mounted) {
      return;
    }

    if (!canAccess) {
      await _showPremiumDialog(context);
      return;
    }

    await _openScanner(context);
  }

  Future<void> _showPremiumDialog(
      BuildContext context,
      ) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 32,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(
              24,
              28,
              24,
              24,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfacePrimary,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lock_rounded,
                  size: 62,
                  color: AppColors.homeBrown,
                ),

                const SizedBox(height: 14),

                Text(
                  context.l10n.goPremiumToUnlockFeature,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.homeBrown,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(
                        dialogContext,
                      ).pop();

                      PremiumNavigation.openPaywall(
                        context,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor:
                      AppColors.brandPrimary,
                      foregroundColor:
                      AppColors.onPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                      ),
                      shape: const StadiumBorder(),
                    ),
                    child: Text(
                      context.l10n.goPremium,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openScanner(
      BuildContext context,
      ) async {
    final result =
    await Navigator.of(context).push<BarcodeFoodData>(
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
          borderRadius: BorderRadius.circular(22),
          child: Ink(
            width: 170,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.surfacePrimary,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: AppColors.calendarCompleted,
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.qr_code_scanner_rounded,
                  color: AppColors.calendarCompleted,
                  size: 21,
                ),

                const SizedBox(width: 9),

                Text(
                  context.l10n.addWithBarcode,
                  style:
                  AppTextStyles.labelMedium.copyWith(
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