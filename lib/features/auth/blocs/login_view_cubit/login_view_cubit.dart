import 'package:bloc/bloc.dart';

part 'login_view_state.dart';

class LoginViewCubit extends Cubit<LoginViewState> {
  LoginViewCubit() : super(LoginViewState(obsecureText: true));

  void toggleObscureText() =>
      emit(LoginViewState(obsecureText: !state.obsecureText));
}
