import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthUser extends Equatable {
  final String email;
  final String name;
  final bool isVerified;

  const AuthUser({
    required this.email,
    required this.name,
    required this.isVerified,
  });

  factory AuthUser.fromUser(User user, {String? displayName}) => AuthUser(
    email: user.email!,
    name: displayName ?? user.displayName!,
    isVerified: user.emailVerified,
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "name": name,
    "isVerified": isVerified,
  };

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
    email: json["email"],
    name: json["name"],
    isVerified: json["isVerified"],
  );

  @override
  String toString() =>
      "AuthUser(email: $email, name: $name, isVerified: $isVerified)";

  @override
  List<Object?> get props => [email, name, isVerified];
}
