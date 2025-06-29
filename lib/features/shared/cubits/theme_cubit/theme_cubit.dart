import 'package:bloc/bloc.dart';

import 'package:flutter/material.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeDarkState());

  void toggleTheme() {
    if (state is ThemeDarkState) {
      emit(ThemeLightState());
    } else {
      emit(ThemeDarkState());
    }
  }

  void setTheme(Brightness brightness) {
    switch (brightness) {
      case Brightness.dark:
        emit(ThemeDarkState());
        break;
      case Brightness.light:
        emit(ThemeLightState());
        break;
    }
  }
}
