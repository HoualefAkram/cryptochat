import 'package:cryptochat/features/auth/models/auth_user.dart';

abstract class AuthenticationProvider {
  Future<AuthUser?> initialize();
  Future<AuthUser> login({required String email, required String password});
  Future<void> logout();
  Future<AuthUser> register({
    required String email,
    required String password,
    required String name,
  });
  Future<void> confirmEmail({required String email});
  Future<void> resetPassword({required String email});
}
