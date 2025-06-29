import 'package:flutter/material.dart';

class CAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Leading leading;
  final Color? color;
  const CAppBar({super.key, this.leading = Leading.none, this.color});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: color ?? Theme.of(context).scaffoldBackgroundColor,
      leading: _getLeading(context, leading),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  Widget _getLeading(BuildContext context, Leading leading) {
    switch (leading) {
      case Leading.back:
        return IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        );
      case Leading.menu:
        return IconButton(onPressed: () {}, icon: const Icon(Icons.menu));
      case Leading.none:
        return SizedBox.shrink();
    }
  }
}

enum Leading { back, menu, none }
