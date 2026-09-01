import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:fiteo_myapp/features/membership/data/membership_repository.dart';
import 'package:fiteo_myapp/features/membership/data/premium_access_service.dart';
import 'package:fiteo_myapp/features/membership/domain/premium_feature.dart';

class FakeMembershipRepository implements MembershipRepository {
  FakeMembershipRepository({
    required bool isPremium,
  }) : _isPremium = isPremium;

  bool _isPremium;

  final StreamController<bool> _controller =
  StreamController<bool>.broadcast();

  void setPremium(bool value) {
    _isPremium = value;
    _controller.add(value);
  }

  @override
  Future<bool> isPremium() async {
    return _isPremium;
  }

  @override
  Stream<bool> watchIsPremium() {
    return _controller.stream;
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}

void main() {
  group('PremiumAccessService', () {
    test('free user cannot access premium features', () async {
      final repository = FakeMembershipRepository(
        isPremium: false,
      );

      final service = PremiumAccessService(
        membershipRepository: repository,
      );

      for (final feature in PremiumFeature.values) {
        expect(
          await service.canAccess(feature),
          isFalse,
        );
      }

      await repository.dispose();
    });

    test('premium user can access premium features', () async {
      final repository = FakeMembershipRepository(
        isPremium: true,
      );

      final service = PremiumAccessService(
        membershipRepository: repository,
      );

      for (final feature in PremiumFeature.values) {
        expect(
          await service.canAccess(feature),
          isTrue,
        );
      }

      await repository.dispose();
    });

    test('isPremium reflects membership state', () async {
      final repository = FakeMembershipRepository(
        isPremium: false,
      );

      final service = PremiumAccessService(
        membershipRepository: repository,
      );

      expect(
        await service.isPremium(),
        isFalse,
      );

      repository.setPremium(true);

      expect(
        await service.isPremium(),
        isTrue,
      );

      await repository.dispose();
    });

    test('watchAccess emits membership changes', () async {
      final repository = FakeMembershipRepository(
        isPremium: false,
      );

      final service = PremiumAccessService(
        membershipRepository: repository,
      );

      final values = <bool>[];

      final subscription = service
          .watchAccess(
        PremiumFeature.planTracking,
      )
          .listen(values.add);

      repository.setPremium(true);
      repository.setPremium(false);

      await Future<void>.delayed(
        Duration.zero,
      );

      expect(
        values,
        [true, false],
      );

      await subscription.cancel();
      await repository.dispose();
    });
  });
}