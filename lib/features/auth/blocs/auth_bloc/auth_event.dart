part of 'auth_bloc.dart';

class AuthEvent {}

class AuthInitializeEvent extends AuthEvent {}

class AuthRegisterEvent extends AuthEvent {}

class AuthLoginEvent extends AuthEvent {}

class AuthLogoutEvent extends AuthEvent {}

class AuthConfirmEmailEvent extends AuthEvent {}

class AuthResetPasswordEvent extends AuthEvent {}
