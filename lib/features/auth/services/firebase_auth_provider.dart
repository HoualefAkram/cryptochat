import 'package:cryptochat/features/auth/models/auth_user.dart';
import 'package:cryptochat/features/auth/services/auth_exceptions.dart';
import 'package:cryptochat/features/auth/services/auth_provider.dart';
import 'package:cryptochat/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "dart:developer" as dev;

import 'package:firebase_core/firebase_core.dart';

class FirebaseAuthProvider implements AuthenticationProvider {
  FirebaseAuth get _auth => FirebaseAuth.instance;
  @override
  Future<void> confirmEmail({required String email}) async {
    final acs = ActionCodeSettings(
      url:
          'https://yourapp.page.link/emailSignIn', // must match dynamic link setup
      handleCodeInApp: true,
      androidPackageName: 'com.houalef.cryptochat',
      androidInstallApp: true,
      androidMinimumVersion: '23',
      iOSBundleId: 'com.houalef.cryptochat',
    );

    await _auth.sendSignInLinkToEmail(email: email, actionCodeSettings: acs);
  }

  @override
  Future<AuthUser?> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) return null;
    return AuthUser.fromUser(currentUser);
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      final User? user = userCredential.user;
      if (user == null) {
        throw Exception("User is null");
      }
      return AuthUser.fromUser(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        throw AuthInvalidCredentialsException(e.toString());
      } else if (e.code == 'invalid-email') {
        throw AuthInvalidEmailFormatException(e.toString());
      }
      throw AuthFailedToLoginException(e.toString());
    } catch (e) {
      throw AuthFailedToLoginException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    dev.log("Signing out...");
    await _auth.signOut();
  }

  @override
  Future<AuthUser> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      final User? user = userCredential.user;
      if (user == null) {
        throw AuthFailedToRegister("User is null");
      }

      await user.updateDisplayName(name);
      await user.reload();

      return AuthUser.fromUser(user, displayName: name);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        throw AuthInvalidEmailFormatException(e.toString());
      }
      throw AuthFailedToLoginException(e.toString());
    } catch (e) {
      throw AuthFailedToRegister(e.toString());
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw AuthFailedToSendResetPasswordEmail(e.toString());
    }
  }
}
