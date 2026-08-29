import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/common/utils/app_snackbar.dart';
import 'package:fiteo_myapp/common/widgets/system_navigation_bar.dart';

import 'package:fiteo_myapp/features/meals/domain/models/barcode_food_data.dart';
import 'package:fiteo_myapp/features/meals/presentation/widgets/barcode_product_result_card.dart';
import 'package:fiteo_myapp/features/meals/data/barcode_food_service.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({
    super.key,
  });

  @override
  State<BarcodeScannerScreen> createState() =>
      _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState
    extends State<BarcodeScannerScreen> {
  final MobileScannerController _controller =
  MobileScannerController(
    facing: CameraFacing.back,
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  final BarcodeFoodService _barcodeFoodService =
  BarcodeFoodService();

  bool _isLookingUp = false;
  BarcodeFoodData? _product;

  // ============================================================
  // KAMERA YARDIMCILARI
  // ============================================================

  Future<void> _pauseScannerSafely() async {
    try {
      await _controller.pause();
    } catch (_) {
      // Kamera zaten durmuşsa veya henüz başlamadıysa
      // uygulamanın akışını bozma.
    }
  }

  Future<void> _startScannerSafely() async {
    try {
      await _controller.start();
    } catch (_) {
      // Kamera zaten açıksa tekrar başlatmaya çalışma.
    }
  }

  // ============================================================
  // KAMERADAN BARKOD ALGILAMA
  // ============================================================

  Future<void> _handleDetectedBarcode(
      String barcode,
      ) async {
    if (_isLookingUp || _product != null) {
      return;
    }

    final trimmedBarcode = barcode.trim();

    if (trimmedBarcode.isEmpty) {
      return;
    }

    await _pauseScannerSafely();

    if (!mounted) return;

    await _lookupBarcode(
      trimmedBarcode,
    );
  }

  Future<void> _lookupBarcode(
      String barcode,
      ) async {
    final trimmedBarcode =
    barcode.trim();

    if (trimmedBarcode.isEmpty ||
        _isLookingUp ||
        _product != null) {
      return;
    }

    setState(() {
      _isLookingUp = true;
      _product = null;
    });

    final product =
    await _barcodeFoodService.findFood(
      barcode: trimmedBarcode,
    );

    if (!mounted) return;

    if (product == null) {
      setState(() {
        _isLookingUp = false;
      });

      AppSnackbar.showError(
        context,
        context.l10n.barcodeLookupFailed,
      );

      await _startScannerSafely();

      return;
    }

    setState(() {
      _product = product;
      _isLookingUp = false;
    });
  }

  // ============================================================
  // MANUEL BARKOD NUMARASI
  // ============================================================

  Future<void> _openManualBarcodeDialog() async {
    if (_isLookingUp) {
      return;
    }

    await _pauseScannerSafely();

    if (!mounted) return;

    String enteredBarcode = '';

    final barcode = await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surfacePrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          title: Text(
            context.l10n.barcodeNumber,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.homeBrown,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: TextField(
            autofocus: true,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.homeBrown,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              hintText:
              context.l10n.barcodeNumberHint,
              hintStyle:
              AppTextStyles.bodyMedium.copyWith(
                color:
                AppColors.homeSecondaryValue,
                fontSize: 14,
              ),
              filled: true,
              fillColor:
              AppColors.homeCardBackground,
              contentPadding:
              const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color:
                  AppColors.calendarCompleted,
                  width: 1.2,
                ),
              ),
            ),

            // Controller kullanmıyoruz.
            onChanged: (value) {
              enteredBarcode = value.trim();
            },

            onSubmitted: (value) {
              final submittedBarcode =
              value.trim();

              if (submittedBarcode.isEmpty) {
                return;
              }

              Navigator.of(dialogContext).pop(
                submittedBarcode,
              );
            },
          ),
          actionsPadding:
          const EdgeInsets.fromLTRB(
            18,
            0,
            18,
            16,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                context.l10n.barcodeCancel,
                style:
                AppTextStyles.labelMedium
                    .copyWith(
                  color: AppColors
                      .planTrackingSecondaryLabel,
                  fontSize: 14,
                  fontWeight:
                  FontWeight.w700,
                ),
              ),
            ),

            TextButton(
              onPressed: () {
                if (enteredBarcode.isEmpty) {
                  return;
                }

                Navigator.of(dialogContext).pop(
                  enteredBarcode,
                );
              },
              child: Text(
                context.l10n.barcodeSearch,
                style:
                AppTextStyles.labelMedium
                    .copyWith(
                  color:
                  AppColors.calendarCompleted,
                  fontSize: 14,
                  fontWeight:
                  FontWeight.w800,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    // Dialog kapatıldı / Vazgeçildi.
    if (barcode == null ||
        barcode.trim().isEmpty) {
      await _startScannerSafely();
      return;
    }

    // Burada kamera zaten durmuş durumda.
    // _lookupBarcode içinde tekrar pause YOK.
    await _lookupBarcode(
      barcode.trim(),
    );
  }

  // ============================================================
  // ÜRÜNÜ YEMEĞE EKLE
  // ============================================================

  void _addProduct() {
    final product = _product;

    if (product == null) {
      return;
    }

    Navigator.pop(
      context,
      product,
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding =
        MediaQuery.paddingOf(context).top;

    final bottomPadding =
        MediaQuery.paddingOf(context).bottom;

    return SystemNavigationBar(
      color: Colors.black,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // ==================================================
            // KAMERA
            // ==================================================

            MobileScanner(
              controller: _controller,
              tapToFocus: true,
              fit: BoxFit.cover,
              onDetect: (capture) {
                if (_isLookingUp ||
                    _product != null ||
                    capture.barcodes.isEmpty) {
                  return;
                }

                final barcode =
                    capture.barcodes
                        .first
                        .rawValue;

                if (barcode == null ||
                    barcode.trim().isEmpty) {
                  return;
                }

                _handleDetectedBarcode(
                  barcode,
                );
              },
              errorBuilder: (
                  context,
                  error,
                  ) {
                return Container(
                  color: Colors.black,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons
                        .no_photography_outlined,
                    color: Colors.white70,
                    size: 62,
                  ),
                );
              },
            ),

            // Kamerayı hafif karartır.
            Container(
              color: Colors.black.withValues(
                alpha: 0.12,
              ),
            ),

            // ==================================================
            // BARKOD ÇERÇEVESİ
            // ==================================================

            if (_product == null &&
                !_isLookingUp)
              Center(
                child: Container(
                  width: 275,
                  height: 155,
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(
                      26,
                    ),
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                ),
              ),

            // ==================================================
            // TARAMA AÇIKLAMASI
            // ==================================================

            if (_product == null &&
                !_isLookingUp)
              Positioned(
                top: topPadding + 150,
                left: 30,
                right: 30,
                child: Text(
                  context.l10n.barcodeScanHint,
                  textAlign:
                  TextAlign.center,
                  style:
                  AppTextStyles.bodyMedium
                      .copyWith(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ),

            // ==================================================
            // SOL ÜST X
            // ==================================================

            Positioned(
              top: topPadding + 10,
              left: 16,
              child: _CameraActionButton(
                icon: Icons.close_rounded,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),

            // ==================================================
            // SAĞ ÜST BARKOD NUMARASI YAZ
            // ==================================================

            if (_product == null)
              Positioned(
                top: topPadding + 10,
                right: 16,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap:
                    _openManualBarcodeDialog,
                    borderRadius:
                    BorderRadius.circular(
                      22,
                    ),
                    child: Ink(
                      height: 44,
                      padding: const EdgeInsets
                          .symmetric(
                        horizontal: 15,
                      ),
                      decoration:
                      BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(
                          22,
                        ),
                      ),
                      child: Row(
                        mainAxisSize:
                        MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.dialpad_rounded,
                            color:
                            AppColors.homeBrown,
                            size: 18,
                          ),

                          const SizedBox(
                            width: 7,
                          ),

                          Text(
                            context.l10n
                                .enterBarcodeNumber,
                            style: AppTextStyles
                                .labelSmall
                                .copyWith(
                              color: AppColors
                                  .homeBrown,
                              fontSize: 12,
                              fontWeight:
                              FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // ==================================================
            // FLAŞ
            // ==================================================

            if (_product == null &&
                !_isLookingUp)
              Positioned(
                bottom: bottomPadding + 40,
                left: 0,
                right: 0,
                child: Center(
                  child:
                  ValueListenableBuilder<
                      MobileScannerState>(
                    valueListenable:
                    _controller,
                    builder: (
                        context,
                        state,
                        child,
                        ) {
                      final torchOn =
                          state.torchState ==
                              TorchState.on;

                      return _CameraActionButton(
                        icon: torchOn
                            ? Icons
                            .flash_on_rounded
                            : Icons
                            .flash_off_rounded,
                        onTap: () {
                          _controller
                              .toggleTorch();
                        },
                      );
                    },
                  ),
                ),
              ),

            // ==================================================
            // ÜRÜN ARANIYOR
            // ==================================================

            if (_isLookingUp)
              Positioned.fill(
                child: Container(
                  color:
                  Colors.black.withValues(
                    alpha: 0.45,
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets
                          .symmetric(
                        horizontal: 24,
                        vertical: 18,
                      ),
                      decoration:
                      BoxDecoration(
                        color: AppColors
                            .surfacePrimary,
                        borderRadius:
                        BorderRadius.circular(
                          22,
                        ),
                      ),
                      child: Column(
                        mainAxisSize:
                        MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 26,
                            height: 26,
                            child:
                            CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppColors
                                  .calendarCompleted,
                            ),
                          ),

                          const SizedBox(
                            height: 12,
                          ),

                          Text(
                            context.l10n
                                .barcodeLookingUp,
                            style: AppTextStyles
                                .bodyMedium
                                .copyWith(
                              color: AppColors
                                  .homeBrown,
                              fontSize: 13,
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // ==================================================
            // BULUNAN ÜRÜN
            // ==================================================

            if (_product != null)
              Align(
                alignment:
                Alignment.bottomCenter,
                child:
                BarcodeProductResultCard(
                  data: _product!,
                  onAdd: _addProduct,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// KAMERA BUTONU
// ============================================================

class _CameraActionButton
    extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CameraActionButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder:
        const CircleBorder(),
        child: Ink(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.black.withValues(
              alpha: 0.42,
            ),
            shape: BoxShape.circle,
            border: Border.all(
              color:
              Colors.white.withValues(
                alpha: 0.35,
              ),
            ),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 22,
          ),
        ),
      ),
    );
  }
}