import 'package:flutter/material.dart';

class TextStyleManager {
  static const double _smallSize = 12;
  static const double _mediumSize = 14;
  static const double _largeSize = 16;

  static final TextStyle _defaultStyle = TextStyle(fontFamily: "Roboto");

  static TextStyle small({bool bold = false, Color? color}) {
    return _defaultStyle.copyWith(
      fontSize: _smallSize,
      color: color,
      fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
    );
  }

  static TextStyle medium({bool bold = false, Color? color}) {
    return _defaultStyle.copyWith(
      fontSize: _mediumSize,
      color: color,
      fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
    );
  }

  static TextStyle large({bool bold = false, Color? color}) {
    return _defaultStyle.copyWith(
      fontSize: _largeSize,
      color: color,
      fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
    );
  }

  static TextStyle get hintText => large(color: Colors.grey);
}
