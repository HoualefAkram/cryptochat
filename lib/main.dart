import 'package:cryptochat/features/auth/blocs/auth_bloc/auth_bloc.dart';

import 'package:cryptochat/features/auth/blocs/obscure_text_cubit/obscure_text_cubit.dart';
import 'package:cryptochat/features/auth/services/auth_service.dart';
import 'package:cryptochat/features/auth/views/login_view.dart';
import 'package:cryptochat/features/online_chat/cubits/chat_cubit/online_chat_cubit.dart';
import 'package:cryptochat/features/online_chat/views/chat_view.dart';
import 'package:cryptochat/features/offline_chat/views/local_chat_view.dart';
import 'package:cryptochat/features/shared/cubits/theme_cubit/theme_cubit.dart';

import 'package:cryptochat/features/shared/utils/routing/router.dart';
import 'package:cryptochat/features/shared/utils/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => AuthBloc(AuthService.firebase())),
        BlocProvider(create: (context) => OnlineChatCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'Akram',
            onGenerateRoute: ScreenRouter.onGenerateRoute,
            theme: themeState is ThemeDarkState
                ? CustomTheme.dark
                : CustomTheme.light,
            home: const Main(),
            builder: (context, child) {
              return MediaQuery.withNoTextScaling(child: child!);
            },
          );
        },
      ),
    ),
  );
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  void initState() {
    context.read<AuthBloc>().add(AuthInitializeEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LocalChatView();
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is AuthLoggedInState) {
          return ChatView();
        } else if (authState is AuthLoggedOutState) {
          return BlocProvider(
            create: (context) => ObscureTextCubit(),
            child: LoginView(),
          );
        } else {
          // Uninitialized
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
