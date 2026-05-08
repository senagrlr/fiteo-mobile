import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> login({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String username,
    required String birthDate,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await credential.user?.sendEmailVerification();

    final user = credential.user;

    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': email,
        'username': username,
        'birthDate': birthDate,
        'authProvider': 'password',
        'emailVerified': user.emailVerified,
        'isOnboardingCompleted': false,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    return credential;
  }

  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;

    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<bool> isCurrentUserEmailVerified() async {
    final user = _auth.currentUser;

    if (user == null) {
      return false;
    }

    await user.reload();

    final refreshedUser = _auth.currentUser;
    final isVerified = refreshedUser?.emailVerified ?? false;

    if (refreshedUser != null) {
      await _firestore.collection('users').doc(refreshedUser.uid).update({
        'emailVerified': isVerified,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    return isVerified;
  }

  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize(
        serverClientId: '753538795015-rte2nnne0q0a3eig3k0a6841kea79je1.apps.googleusercontent.com',
      );

      final GoogleSignInAccount googleUser =
      await googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth =
          googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      final user = userCredential.user;

      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();

        if (!doc.exists) {
          await _firestore.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'email': user.email,
            'username': user.displayName ?? '',
            'birthDate': null,
            'authProvider': 'google',
            'emailVerified': true,
            'isOnboardingCompleted': false,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      }

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isOnboardingCompleted(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();

    if (!doc.exists) return false;

    final data = doc.data();
    return data?['isOnboardingCompleted'] == true;
  }

  Future<void> logout() {
    return _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}