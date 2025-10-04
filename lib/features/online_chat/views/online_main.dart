import 'package:cryptochat/features/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:cryptochat/features/auth/blocs/obscure_text_cubit/obscure_text_cubit.dart';
import 'package:cryptochat/features/auth/views/login_view.dart';
import 'package:cryptochat/features/online_chat/views/online_chat_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnlineChatMain extends StatefulWidget {
  const OnlineChatMain({super.key});

  @override
  State<OnlineChatMain> createState() => _OnlineChatMainState();
}

class _OnlineChatMainState extends State<OnlineChatMain> {
  @override
  void initState() {
    context.read<AuthBloc>().add(AuthInitializeEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is AuthLoggedInState) {
          return OnlineChatView();
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
