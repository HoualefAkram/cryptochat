import 'package:flutter/material.dart';

typedef OnPop = void Function();

class CAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Leading leading;
  final Color? color;
  final Color? leadingColor;
  final OnPop? onPop;
  final Widget? title;
  final List<Widget>? actions;
  final bool centerTitle;

  const CAppBar({
    super.key,
    this.leading = Leading.none,
    this.color,
    this.title,
    this.actions,
    this.leadingColor,
    this.onPop,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: color ?? Theme.of(context).scaffoldBackgroundColor,
      leading: _getLeading(
        context: context,
        leading: leading,
        color: leadingColor,
        onPop: onPop,
      ),
      centerTitle: centerTitle,
      title: title,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  Widget _getLeading({
    required BuildContext context,
    required Leading leading,
    Color? color,
    OnPop? onPop,
  }) {
    switch (leading) {
      case Leading.back:
        return IconButton(
          onPressed: () {
            if (onPop != null) {
              onPop.call();
              return;
            }
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_rounded, color: color),
        );
      case Leading.menu:
        return IconButton(
          onPressed: () {},
          icon: Icon(Icons.menu, color: color),
        );
      case Leading.none:
        return SizedBox.shrink();
    }
  }
}

enum Leading { back, menu, none }
