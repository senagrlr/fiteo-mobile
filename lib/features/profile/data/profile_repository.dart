import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Future<DocumentSnapshot<Map<String, dynamic>>> getCurrentUserDoc() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    return _firestore.collection('users').doc(user.uid).get();
  }

  Future<void> updateProfileInfo({
    required String username,
    String? mascotPath,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final data = <String, dynamic>{
      'username': username,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (mascotPath != null) {
      data['mascot'] = mascotPath;
    }

    await _firestore.collection('users').doc(user.uid).update(data);
  }

  Future<void> updateUserPreferences(Map<String, dynamic> preferences) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final updates = <String, dynamic>{
      'updatedAt': FieldValue.serverTimestamp(),
    };

    preferences.forEach((key, value) {
      updates['userPreferences.$key'] = value;
    });

    await _firestore.collection('users').doc(user.uid).update(updates);
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;

    if (user == null || user.email == null) {
      throw Exception('User not logged in');
    }

    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );

    await user.reauthenticateWithCredential(credential);
    await user.updatePassword(newPassword);
  }

  Future<void> deleteAccount({
    String? currentPassword,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final doc = await _firestore.collection('users').doc(user.uid).get();
    final authProvider = doc.data()?['authProvider'];

    if (authProvider == 'password') {
      if (currentPassword == null || currentPassword.isEmpty) {
        throw Exception('Current password required');
      }

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);
    }

    if (authProvider == 'google') {
      final googleUser = await GoogleSignIn.instance.authenticate();

      final googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      await user.reauthenticateWithCredential(credential);
    }

    await _firestore.collection('users').doc(user.uid).delete();

    await user.delete();
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}