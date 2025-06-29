part of 'auth_bloc.dart';

class AuthState {
  final bool isLoading;

  AuthState({this.isLoading = false});
}

final class AuthUninitializedState extends AuthState {
  AuthUninitializedState({super.isLoading});
}

final class AuthLoggedInState extends AuthState {
  final AuthUser user;
  AuthLoggedInState({required this.user, super.isLoading = false});
}

final class AuthLoggedOutState extends AuthState {
  final Exception? execption;
  AuthLoggedOutState({this.execption, super.isLoading = false});
}
