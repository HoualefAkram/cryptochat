import 'package:cryptochat/features/shared/utils/themes/text_style_manager.dart';
import 'package:flutter/material.dart';

class CustomTheme {
  static final dark = ThemeData(
    primaryColor: Colors.blueAccent,
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: Colors.blueAccent,
    ),
    scaffoldBackgroundColor: CustomColors.backgroundBlue,
    iconTheme: IconThemeData(color: Colors.white),
    textTheme: TextTheme(
      bodyLarge: TextStyleManager.large(color: Colors.white),
      bodyMedium: TextStyleManager.medium(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.blueAccent),
        foregroundColor: WidgetStatePropertyAll(Colors.white),
        textStyle: WidgetStatePropertyAll(TextStyleManager.large()),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(Colors.white),
        textStyle: WidgetStatePropertyAll(TextStyleManager.large()),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(Colors.blueAccent),
        side: WidgetStatePropertyAll(BorderSide(color: Colors.blueAccent)),
        textStyle: WidgetStatePropertyAll(TextStyleManager.large()),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(iconColor: WidgetStatePropertyAll(Colors.white)),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.white,
      selectionHandleColor: Colors.blueAccent,
      selectionColor: Colors.blueAccent.withAlpha(40),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyleManager.hintText,
      labelStyle: TextStyleManager.hintText,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      suffixIconColor: Colors.grey,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueGrey),
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
  static final light = ThemeData.from(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  );
}

class CustomColors {
  static final Color backgroundBlue = Color(0XFF121F28);
}
