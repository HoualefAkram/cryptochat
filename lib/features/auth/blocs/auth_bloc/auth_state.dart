part of 'auth_bloc.dart';

class AuthState {}

final class AuthUninitializedState extends AuthState {
  final Exception? execption;
  AuthUninitializedState({this.execption});
}

final class AuthInitializedState extends AuthState {
  final AuthUser user;
  AuthInitializedState({required this.user});
}

final class AuthLoadingState extends AuthState {}
