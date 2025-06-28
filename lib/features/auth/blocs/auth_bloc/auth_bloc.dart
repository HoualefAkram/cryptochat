import 'package:bloc/bloc.dart';
import 'package:cryptochat/features/auth/models/auth_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthUninitializedState()) {
    on<AuthInitializeEvent>((event, emit) {});

    on<AuthLoginEvent>((event, emit) {});

    on<AuthLogoutEvent>((event, emit) {});

    on<AuthRegisterEvent>((event, emit) {});

    on<AuthConfirmEmailEvent>((event, emit) {});

    on<AuthResetPasswordEvent>((event, emit) {});
  }
}
