import 'package:cryptochat/features/auth/views/login_view.dart';
import 'package:cryptochat/features/auth/views/register_view.dart';
import 'package:cryptochat/features/chat/views/chat_view.dart';
import 'package:cryptochat/features/shared/utils/routing/routes.dart';
import 'package:cryptochat/main.dart';
import 'package:flutter/material.dart';

class ScreenRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
        return MaterialPageRoute(
          settings: RouteSettings(name: Routes.home),
          builder: (context) => Main(),
        );

      case Routes.login:
        return MaterialPageRoute(
          settings: RouteSettings(name: Routes.login),
          builder: (context) => LoginView(),
        );
      case Routes.register:
        return MaterialPageRoute(
          settings: RouteSettings(name: Routes.register),
          builder: (context) => RegisterView(),
        );
      case Routes.chat:
        return MaterialPageRoute(
          settings: RouteSettings(name: Routes.chat),
          builder: (context) => ChatView(),
        );
      default:
        return null;
    }
  }
}
