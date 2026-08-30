import 'package:fiteo_myapp/features/membership/data/membership_repository.dart';
import 'package:fiteo_myapp/features/membership/domain/premium_feature.dart';

class PremiumAccessService {
  final MembershipRepository _membershipRepository;

  PremiumAccessService({
    MembershipRepository? membershipRepository,
  }) : _membershipRepository =
      membershipRepository ?? MembershipRepository();

  Future<bool> isPremium() {
    return _membershipRepository.isPremium();
  }

  Stream<bool> watchIsPremium() {
    return _membershipRepository.watchIsPremium();
  }

  Future<bool> canAccess(PremiumFeature feature) async {
    return _membershipRepository.isPremium();
  }

  Stream<bool> watchAccess(PremiumFeature feature) {
    return _membershipRepository.watchIsPremium();
  }
}