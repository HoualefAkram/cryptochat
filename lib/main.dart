import 'package:cryptochat/features/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:cryptochat/features/auth/services/auth_service.dart';
import 'package:cryptochat/features/auth/views/login_view.dart';
import 'package:cryptochat/features/chat/services/chat_service.dart';
import 'package:cryptochat/features/chat/views/chat_view.dart';
import 'package:cryptochat/features/shared/utils/routing/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ChatService.initialize();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(AuthService.firebase())),
      ],
      child: MaterialApp(
        title: 'Akram',
        onGenerateRoute: ScreenRouter.onGenerateRoute,
        home: const Main(),
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
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is AuthLoggedInState) {
          return ChatView();
        } else if (authState is AuthLoggedOutState) {
          return LoginView();
        } else {
          // Uninitialized
          return CircularProgressIndicator();
        }
      },
    );
  }
}
