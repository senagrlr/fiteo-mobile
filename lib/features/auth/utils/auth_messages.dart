import 'package:firebase_auth/firebase_auth.dart';

class AuthMessages {
  static const fillAllFields = 'Fill in all fields';
  static const emailAndPasswordEmpty = 'Email and password cannot be left blank.';
  static const enterEmail = 'Please enter your email address.';

  static const passwordTooShort = 'Password must be at least 8 characters';

  static const loginSuccess = 'Login successful';
  static const wrongEmailOrPassword = 'Email or password is incorrect.';

  static const emailVerifiedSuccessfully = 'Email verified successfully.';
  static const emailNotVerifiedYet = 'Your email is not verified yet.';
  static const verificationEmailSentAgain = 'Verification email sent again.';
  static const verificationEmailCouldNotSend = 'Could not resend verification email.';

  static const resetLinkSent = 'Reset link has been sent.';
  static const resetLinkCouldNotSend = 'Could not send reset link.';

  static const emailAlreadyRegistered = 'This email is already registered.';
  static const invalidEmail = 'Invalid email address.';
  static const somethingWentWrong = 'Something went wrong.';
}

String authErrorMessage(FirebaseAuthException e) {
  switch (e.code) {
    case 'invalid-email':
      return AuthMessages.invalidEmail;
    case 'email-already-in-use':
      return AuthMessages.emailAlreadyRegistered;
    case 'wrong-password':
    case 'user-not-found':
    case 'invalid-credential':
      return AuthMessages.wrongEmailOrPassword;
    default:
      return AuthMessages.somethingWentWrong;
  }
}