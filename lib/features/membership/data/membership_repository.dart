import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MembershipRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  MembershipRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore =
            firestore ?? FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>>?
  _membershipRef() {
    final user = _auth.currentUser;

    if (user == null) {
      return null;
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('membership')
        .doc('current');
  }

  Future<bool> isPremium() async {
    final ref = _membershipRef();

    if (ref == null) {
      return false;
    }

    final snapshot = await ref.get();
    final data = snapshot.data();

    if (data == null) {
      return false;
    }

    return data['isPremium'] == true &&
        data['status'] == 'active';
  }

  Stream<bool> watchIsPremium() {
    final ref = _membershipRef();

    if (ref == null) {
      return Stream.value(false);
    }

    return ref.snapshots().map((snapshot) {
      final data = snapshot.data();

      if (data == null) {
        return false;
      }

      return data['isPremium'] == true &&
          data['status'] == 'active';
    });
  }
}