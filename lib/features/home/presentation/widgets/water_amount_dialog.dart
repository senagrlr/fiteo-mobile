import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';

class WaterAmountDialog extends StatefulWidget {
  const WaterAmountDialog({super.key});

  @override
  State<WaterAmountDialog> createState() => _WaterAmountDialogState();
}

class _WaterAmountDialogState extends State<WaterAmountDialog> {
  static const int minAmount = 0;
  static const int maxAmount = 250;

  int selectedAmount = 150;
  bool isEditingAmount = false;

  late final TextEditingController amountController;
  late final FocusNode amountFocusNode;

  @override
  void initState() {
    super.initState();

    amountController = TextEditingController(
      text: selectedAmount.toString(),
    );

    amountFocusNode = FocusNode();
  }

  @override
  void dispose() {
    amountController.dispose();
    amountFocusNode.dispose();
    super.dispose();
  }

  void _updateAmountFromPosition({
    required double localY,
    required double height,
  }) {
    final normalizedPosition = (1 - (localY / height)).clamp(0.0, 1.0);
    final amount = (normalizedPosition * maxAmount).round();

    setState(() {
      selectedAmount = amount.clamp(minAmount, maxAmount);
    });
  }

  void _startEditingAmount() {
    setState(() {
      isEditingAmount = true;
      amountController.text = selectedAmount.toString();
      amountController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: amountController.text.length,
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      amountFocusNode.requestFocus();
    });
  }

  void _cancelEditingAmount() {
    amountFocusNode.unfocus();

    setState(() {
      isEditingAmount = false;
      amountController.text = selectedAmount.toString();
    });
  }

  void _drinkEditedAmount() {
    final value = int.tryParse(
      amountController.text.trim(),
    );

    if (value == null) {
      return;
    }

    final amount = value.clamp(minAmount, maxAmount);

    amountFocusNode.unfocus();

    Navigator.pop(
      context,
      amount,
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
    final isKeyboardVisible = keyboardHeight > 0;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: EdgeInsets.fromLTRB(
        28,
        20,
        28,
        isKeyboardVisible ? keyboardHeight + 12 : 30,
      ),
      child: Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        child: SingleChildScrollView(
          keyboardDismissBehavior:
          ScrollViewKeyboardDismissBehavior.onDrag,
          child: Container(
            width: 330,
            padding: EdgeInsets.fromLTRB(
              24,
              isEditingAmount ? 22 : 18,
              24,
              isEditingAmount ? 20 : 28,
            ),
            decoration: BoxDecoration(
              color: AppColors.waterDialogBackground,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      if (isEditingAmount) {
                        _cancelEditingAmount();
                        return;
                      }

                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.waterDialogText,
                      size: 30,
                    ),
                  ),
                ),
                if (!isEditingAmount) ...[
                  const SizedBox(height: 2),
                  SizedBox(
                    width: 170,
                    height: 230,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTapDown: (details) {
                            _updateAmountFromPosition(
                              localY: details.localPosition.dy,
                              height: constraints.maxHeight,
                            );
                          },
                          onVerticalDragUpdate: (details) {
                            _updateAmountFromPosition(
                              localY: details.localPosition.dy,
                              height: constraints.maxHeight,
                            );
                          },
                          child: CustomPaint(
                            painter: WaterGlassPainter(
                              progress: selectedAmount / maxAmount,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          '$selectedAmount ml',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.waterDialogText,
                            fontSize: 38,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _startEditingAmount,
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: AppColors.waterEditIcon,
                          size: 23,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  SizedBox(
                    width: 185,
                    height: 58,
                    child: ElevatedButton(
                      onPressed: selectedAmount <= 0
                          ? null
                          : () {
                        Navigator.pop(
                          context,
                          selectedAmount,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        AppColors.waterDrinkButton,
                        disabledBackgroundColor:
                        AppColors.waterDrinkButtonDisabled,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Drink',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
                if (isEditingAmount) ...[
                  const Text(
                    'Enter water amount',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.waterDialogText,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: amountController,
                    focusNode: amountFocusNode,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    decoration: InputDecoration(
                      suffixText: 'ml',
                      hintText: '0 - 250',
                      filled: true,
                      fillColor:
                      AppColors.waterDialogInputBackground,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) {
                      _drinkEditedAmount();
                    },
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _cancelEditingAmount,
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color:
                            AppColors.waterDialogSecondaryText,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: _drinkEditedAmount,
                        child: const Text(
                          'Drink',
                          style: TextStyle(
                            color: AppColors.waterDialogText,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WaterGlassPainter extends CustomPainter {
  const WaterGlassPainter({
    required this.progress,
  });

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final glassPath = Path()
      ..moveTo(size.width * 0.12, size.height * 0.10)
      ..quadraticBezierTo(
        size.width * 0.50,
        size.height * 0.02,
        size.width * 0.88,
        size.height * 0.10,
      )
      ..lineTo(
        size.width * 0.78,
        size.height * 0.88,
      )
      ..quadraticBezierTo(
        size.width * 0.50,
        size.height * 0.98,
        size.width * 0.22,
        size.height * 0.88,
      )
      ..close();

    final glassPaint = Paint()
      ..color = AppColors.waterGlassBackground
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    canvas.drawPath(glassPath, glassPaint);

    canvas.save();
    canvas.clipPath(glassPath);

    final waterTop = size.height *
        (0.88 - (progress.clamp(0.0, 1.0) * 0.70));

    final waterPath = Path()
      ..moveTo(0, waterTop)
      ..quadraticBezierTo(
        size.width * 0.50,
        waterTop - 13,
        size.width,
        waterTop,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final waterPaint = Paint()
      ..color = AppColors.waterGlassFill
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    canvas.drawPath(waterPath, waterPaint);
    canvas.restore();

    final topWaterPaint = Paint()
      ..color = AppColors.waterGlassTop
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final topOval = Rect.fromCenter(
      center: Offset(
        size.width * 0.50,
        size.height * 0.10,
      ),
      width: size.width * 0.72,
      height: size.height * 0.14,
    );

    canvas.drawOval(topOval, topWaterPaint);

    final outlinePaint = Paint()
      ..color = AppColors.waterGlassOutline
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    canvas.drawPath(glassPath, outlinePaint);

    final handleCenter = Offset(
      size.width * 0.50,
      waterTop,
    );

    final handlePaint = Paint()
      ..color = AppColors.waterGlassHandle
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    canvas.drawCircle(
      handleCenter,
      18,
      handlePaint,
    );

    final iconPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    final upArrow = Path()
      ..moveTo(
        handleCenter.dx - 7,
        handleCenter.dy - 2,
      )
      ..lineTo(
        handleCenter.dx,
        handleCenter.dy - 9,
      )
      ..lineTo(
        handleCenter.dx + 7,
        handleCenter.dy - 2,
      );

    final downArrow = Path()
      ..moveTo(
        handleCenter.dx - 7,
        handleCenter.dy + 3,
      )
      ..lineTo(
        handleCenter.dx,
        handleCenter.dy + 10,
      )
      ..lineTo(
        handleCenter.dx + 7,
        handleCenter.dy + 3,
      );

    canvas.drawPath(upArrow, iconPaint);
    canvas.drawPath(downArrow, iconPaint);
  }

  @override
  bool shouldRepaint(
      covariant WaterGlassPainter oldDelegate,
      ) {
    return oldDelegate.progress != progress;
  }
}