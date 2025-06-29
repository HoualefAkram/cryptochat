import 'package:firebase_auth/firebase_auth.dart';

class AuthUser {
  final String email;
  final String name;
  final bool isVerified;

  AuthUser({required this.email, required this.name, required this.isVerified});

  factory AuthUser.fromUser(User user) => AuthUser(
    email: user.email!,
    name: user.displayName!,
    isVerified: user.emailVerified,
  );

  @override
  String toString() =>
      "AuthUser(email: $email, name: $name, isVerified: $isVerified)";
}
