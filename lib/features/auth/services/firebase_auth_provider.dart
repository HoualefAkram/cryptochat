import 'package:cryptochat/features/auth/models/auth_user.dart';
import 'package:cryptochat/features/auth/services/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      androidMinimumVersion: '21',
      iOSBundleId: 'com.houalef.cryptochat',
    );

    await _auth.sendSignInLinkToEmail(email: email, actionCodeSettings: acs);
  }

  @override
  Future<AuthUser?> initialize() async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) return null;
    return AuthUser.fromUser(currentUser);
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    final UserCredential userCredential = await _auth
        .signInWithEmailAndPassword(email: email, password: password);

    final User? user = userCredential.user;
    if (user == null) {
      throw Exception("User is null");
    }
    return AuthUser.fromUser(user);
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }

  @override
  Future<AuthUser> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final UserCredential userCredential = await _auth
        .createUserWithEmailAndPassword(email: email, password: password);
    final User? user = userCredential.user;
    if (user == null) {
      throw Exception("User is null");
    }
    await user.updateDisplayName(name);
    await user.reload();
    return AuthUser.fromUser(user);
  }

  @override
  Future<void> resetPassword({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
