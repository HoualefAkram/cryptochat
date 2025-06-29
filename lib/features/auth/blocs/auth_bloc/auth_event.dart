part of 'auth_bloc.dart';

class AuthEvent {}

class AuthInitializeEvent extends AuthEvent {}

class AuthRegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;

  AuthRegisterEvent({
    required this.email,
    required this.password,
    required this.name,
  });
}

class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;

  AuthLoginEvent({required this.email, required this.password});
}

class AuthLogoutEvent extends AuthEvent {}

class AuthResetPasswordEvent extends AuthEvent {
  final String email;

  AuthResetPasswordEvent({required this.email});
}
