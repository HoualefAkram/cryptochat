import 'package:bloc/bloc.dart';
import 'package:cryptochat/features/auth/models/auth_user.dart';
import 'package:cryptochat/features/auth/services/auth_service.dart';
import "dart:developer" as dev;
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService auth;

  AuthBloc(this.auth) : super(AuthUninitializedState()) {
    on<AuthInitializeEvent>((event, emit) async {
      emit(AuthUninitializedState(isLoading: true));
      final AuthUser? user = await auth.initialize();
      if (user == null) {
        emit(AuthLoggedOutState());
        return;
      }
      emit(AuthLoggedInState(user: user));
    });

    on<AuthLoginEvent>((event, emit) async {
      try {
        emit(AuthLoggedOutState(isLoading: true));
        final String email = event.email;
        final String password = event.password;
        final AuthUser user = await auth.login(
          email: email,
          password: password,
        );
        emit(AuthLoggedInState(user: user));
      } catch (e, stack) {
        dev.log("(AuthBloc) Failed to login: $e, $stack");
        emit(AuthLoggedOutState(execption: e as Exception));
      }
    });

    on<AuthLogoutEvent>((event, emit) async {
      await auth.logout();
      emit(AuthLoggedOutState());
    });

    on<AuthRegisterEvent>((event, emit) async {
      try {
        emit(AuthLoggedOutState(isLoading: true));
        final String email = event.email;
        final String password = event.password;
        final String name = event.name;
        final AuthUser user = await auth.register(
          email: email,
          password: password,
          name: name,
        );
        dev.log("register user: $user");
        add(AuthLoginEvent(email: email, password: password));
      } catch (e, stack) {
        dev.log("(AuthBloc) Failed to register: $e, $stack");
        emit(AuthLoggedOutState(execption: e as Exception));
      }
    });

    on<AuthConfirmEmailEvent>((event, emit) async {
      final String email = event.email;
      await auth.confirmEmail(email: email);
    });

    on<AuthResetPasswordEvent>((event, emit) async {
      final String email = event.email;
      await auth.resetPassword(email: email);
    });
  }
}
