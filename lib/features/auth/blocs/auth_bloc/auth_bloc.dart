import 'package:bloc/bloc.dart';
import 'package:cryptochat/features/auth/models/auth_user.dart';
import 'package:cryptochat/features/auth/services/auth_exceptions.dart';
import 'package:cryptochat/features/auth/services/auth_service.dart';
import "dart:developer" as dev;

import 'package:cryptochat/features/shared/utils/validator/text_validator.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService auth;

  AuthBloc(this.auth) : super(AuthUninitializedState()) {
    on<AuthInitializeEvent>((event, emit) async {
      final AuthUser? user = await auth.initialize();
      if (user == null) {
        emit(AuthLoggedOutState());
        return;
      }
      emit(AuthLoggedInState(user: user));
    });

    on<AuthLoginEvent>((event, emit) async {
      try {
        final String email = event.email;
        final String password = event.password;
        if (TextValidator.anyEmpty([email, password])) {
          throw AuthInvalidInputException("Invalid input");
        }
        emit(AuthLoggedOutState(isLoading: true));
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
        final String email = event.email;
        final String password = event.password;
        final String name = event.name;
        if (TextValidator.anyEmpty([email, password, name])) {
          throw AuthInvalidInputException("Invalid input");
        }
        emit(AuthLoggedOutState(isLoading: true));
        final AuthUser user = await auth.register(
          email: email,
          password: password,
          name: name,
        );
        dev.log("register user: $user");
        emit(AuthLoggedOutState(registered: true));
      } catch (e, stack) {
        dev.log("(AuthBloc) Failed to register: $e, $stack");
        emit(AuthLoggedOutState(execption: e as Exception));
      }
    });

    on<AuthResetPasswordEvent>((event, emit) async {
      try {
        final String email = event.email;
        if (TextValidator.anyEmpty([email])) {
          throw AuthInvalidInputException("Invalid input");
        }
        emit(AuthLoggedOutState(isLoading: true));
        await auth.resetPassword(email: email);
        emit(AuthLoggedOutState(resetEmailSent: true));
      } catch (e) {
        emit(AuthLoggedOutState(execption: e as Exception));
      }
    });
  }
}
