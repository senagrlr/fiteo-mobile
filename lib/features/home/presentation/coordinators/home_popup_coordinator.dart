import 'package:flutter/material.dart';

import 'package:fiteo_myapp/features/profile/data/weight_repository.dart';

import 'package:fiteo_myapp/features/home/presentation/widgets/weekly_weight_update_sheet.dart';

class HomePopupCoordinator {
  final WeightRepository _weightRepository;

  HomePopupCoordinator({
    WeightRepository? weightRepository,
  }) : _weightRepository =
      weightRepository ?? WeightRepository();

  Future<void> tryShowWeightCheckIn(
      BuildContext context,
      ) async {
    if (!context.mounted) {
      return;
    }

    try {
      final state =
      await _weightRepository.getCheckInState();

      if (!context.mounted ||
          !state.shouldShow ||
          state.currentWeightKg == null) {
        return;
      }

      await _weightRepository.markPromptShown();

      if (!context.mounted) {
        return;
      }

      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withValues(
          alpha: 0.25,
        ),
        isDismissible: true,
        enableDrag: true,
        builder: (sheetContext) {
          return WeeklyWeightUpdateSheet(
            initialWeightKg:
            state.currentWeightKg!,
            unit: state.weightUnit,
            onUpdate: (newWeightKg) async {
              await _weightRepository.saveWeight(
                weightKg: newWeightKg,
              );
            },
          );
        },
      );
    } catch (_) {}
  }
}