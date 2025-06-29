import 'package:cryptochat/features/shared/utils/themes/text_style_manager.dart';
import 'package:flutter/material.dart';

class CustomTheme {
  static final dark = ThemeData(
    primaryColor: CustomColors.primaryBlue,
    appBarTheme: AppBarTheme(
      titleTextStyle: TextStyleManager.large(color: Colors.white, bold: true),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: CustomColors.primaryBlue,
    ),
    scaffoldBackgroundColor: CustomColors.backgroundBlue,
    iconTheme: IconThemeData(color: Colors.white),
    textTheme: TextTheme(
      bodyLarge: TextStyleManager.large(color: Colors.white),
      bodyMedium: TextStyleManager.medium(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(CustomColors.primaryBlue),
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
        foregroundColor: WidgetStatePropertyAll(CustomColors.primaryBlue),
        side: WidgetStatePropertyAll(
          BorderSide(color: CustomColors.primaryBlue),
        ),
        textStyle: WidgetStatePropertyAll(TextStyleManager.large()),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(iconColor: WidgetStatePropertyAll(Colors.white)),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.white,
      selectionHandleColor: CustomColors.primaryBlue,
      selectionColor: CustomColors.primaryBlue.withAlpha(40),
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
  static final Color primaryBlue = Color(0XFF136DFE);
  static final Color activeGreen = Color(0XFF32A73A);
  static final Color bubleGrey = Color(0XFF333333);
}
