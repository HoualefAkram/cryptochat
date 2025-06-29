import 'package:bloc/bloc.dart';

part 'obscure_text_state.dart';

class ObscureTextCubit extends Cubit<ObscureTextState> {
  ObscureTextCubit() : super(ObscureTextState(obsecureText: true));

  void toggleObscureText() =>
      emit(ObscureTextState(obsecureText: !state.obsecureText));
}
