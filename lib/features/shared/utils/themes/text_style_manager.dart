import 'package:flutter/material.dart';

class TextStyleManager {
  static const double _largeSize = 16;

  static const double _mediumSize = 14;

  static TextStyle large({bool bold = false, Color? color}) {
    return TextStyle(
      fontSize: _largeSize,
      color: color,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }

  static TextStyle medium({bool bold = false, Color? color}) {
    return TextStyle(
      fontSize: _mediumSize,
      color: color,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }

  static TextStyle get hintText => large(color: Colors.grey);
}
