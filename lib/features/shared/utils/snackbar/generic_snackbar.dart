import 'package:flutter/material.dart';

class ESnackBar {
  static const _duration = Durations.extralong4;
  static const EdgeInsets _padding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 2,
  );

  static void info(BuildContext context, String text, {Duration? duration}) {
    var scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.showSnackBar(
      SnackBar(
        duration: duration ?? _duration,
        padding: _padding,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.surface,
        content: Row(
          children: [
            Expanded(child: Text(text)),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                scaffoldMessenger.hideCurrentSnackBar();
              },
            ),
          ],
        ),
      ),
    );
  }

  static void error(BuildContext context, String text, {Duration? duration}) {
    var scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.showSnackBar(
      SnackBar(
        duration: duration ?? _duration,
        padding: _padding,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.error,
        content: Row(
          children: [
            Expanded(
              child: Text(text, maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                scaffoldMessenger.hideCurrentSnackBar();
              },
            ),
          ],
        ),
      ),
    );
  }

  static void success(BuildContext context, String text, {Duration? duration}) {
    var scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.showSnackBar(
      SnackBar(
        duration: duration ?? _duration,
        padding: _padding,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        content: Row(
          children: [
            Expanded(child: Text(text)),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                scaffoldMessenger.hideCurrentSnackBar();
              },
            ),
          ],
        ),
      ),
    );
  }
}
