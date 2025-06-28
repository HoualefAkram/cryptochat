import 'package:cryptochat/features/auth/models/auth_user.dart';

abstract class AuthProvider {
  Future<AuthUser?> initialize();
  Future<AuthUser> login();
  Future<void> logout();
  Future<AuthUser> register();
  Future<void> confirmEmail();
  Future<void> resetPassword();
}
