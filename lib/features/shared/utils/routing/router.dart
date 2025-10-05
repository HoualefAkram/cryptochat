import 'package:cryptochat/features/auth/blocs/obscure_text_cubit/obscure_text_cubit.dart';
import 'package:cryptochat/features/auth/views/login_view.dart';
import 'package:cryptochat/features/auth/views/register_view.dart';
import 'package:cryptochat/features/auth/views/reset_password_view.dart';
import 'package:cryptochat/features/offline_chat/cubits/offline_chat_cubit/offline_chat_cubit.dart';
import 'package:cryptochat/features/offline_chat/views/offline_chat_view.dart';
import 'package:cryptochat/features/online_chat/views/online_main.dart';
import 'package:cryptochat/features/shared/utils/routing/routes.dart';
import 'package:cryptochat/features/shared/views/mode_select_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScreenRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
        return MaterialPageRoute(
          settings: RouteSettings(name: Routes.home),
          builder: (context) => ModeSelectView(),
        );

      case Routes.login:
        return MaterialPageRoute(
          settings: RouteSettings(name: Routes.login),
          builder: (context) => BlocProvider(
            create: (context) => ObscureTextCubit(),
            child: LoginView(),
          ),
        );
      case Routes.register:
        return MaterialPageRoute(
          settings: RouteSettings(name: Routes.register),
          builder: (context) => BlocProvider(
            create: (context) => ObscureTextCubit(),
            child: RegisterView(),
          ),
        );

      case Routes.resetPassword:
        return MaterialPageRoute(
          settings: RouteSettings(name: Routes.resetPassword),
          builder: (context) => ResetPasswordView(),
        );
      case Routes.onlineChat:
        return MaterialPageRoute(
          settings: RouteSettings(name: Routes.onlineChat),
          builder: (context) => OnlineChatMain(),
        );
      case Routes.offlineChat:
        return MaterialPageRoute(
          settings: RouteSettings(name: Routes.offlineChat),
          builder: (context) => BlocProvider(
            create: (context) => OfflineChatCubit(),
            child: OfflineChatView(),
          ),
        );
      default:
        return null;
    }
  }
}
