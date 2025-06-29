import 'package:flutter/material.dart' show immutable;

typedef CloseProgressLoadingScreen = bool Function();
typedef UpdateProgressLoadingScreen = bool Function(double progress);

@immutable
class ProgressLoadingScreenContoller {
  final CloseProgressLoadingScreen close;
  final UpdateProgressLoadingScreen update;

  const ProgressLoadingScreenContoller({
    required this.close,
    required this.update,
  });
}
