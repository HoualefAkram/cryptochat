import 'package:cryptochat/features/auth/models/auth_user.dart';
import 'package:cryptochat/features/auth/services/auth_provider.dart';
import 'package:cryptochat/features/auth/services/firebase_auth_provider.dart';

class AuthService implements AuthenticationProvider {
  final AuthenticationProvider provider;

  AuthService({required this.provider});

  factory AuthService.firebase() =>
      AuthService(provider: FirebaseAuthProvider());

  @override
  Future<void> confirmEmail({required String email}) =>
      provider.confirmEmail(email: email);

  @override
  Future<AuthUser?> initialize() => provider.initialize();

  @override
  Future<AuthUser> login({required String email, required String password}) =>
      provider.login(email: email, password: password);

  @override
  Future<void> logout() => provider.logout();

  @override
  Future<AuthUser> register({
    required String email,
    required String password,
    required String name,
  }) => provider.register(email: email, password: password, name: name);

  @override
  Future<void> resetPassword({required String email}) =>
      provider.resetPassword(email: email);
}
