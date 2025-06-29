import 'package:cryptochat/features/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:cryptochat/features/auth/services/auth_exceptions.dart';
import 'package:cryptochat/features/shared/helpers/loading/withoutProgress/loading_screen.dart';
import 'package:cryptochat/features/shared/utils/custom_icon/custom_icon.dart';
import 'package:cryptochat/features/shared/utils/routing/routes.dart';
import 'package:cryptochat/features/shared/utils/snackbar/generic_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, authState) {
        if (authState.isLoading) {
          LoadingScreen().show(context: context);
        } else {
          LoadingScreen().hide();
        }
        if (authState is AuthLoggedOutState) {
          if (authState.execption is AuthInvalidCredentialsException) {
            ESnackBar.error(context, "Invalid Credentials!");
          } else if (authState.execption is AuthInvalidEmailFormatException) {
            ESnackBar.error(context, "Invalid email format!");
          } else if (authState.execption is AuthFailedToLoginException) {
            ESnackBar.error(
              context,
              "Login failed: ${authState.execption.toString()}",
            );
          }
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIcon.build(CIcon.messenger, height: 100, width: 100),
              TextField(
                controller: emailController,
                decoration: InputDecoration(hint: Text("Email")),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(hint: Text("Passwrod")),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                    AuthLoginEvent(
                      email: emailController.text,
                      password: passwordController.text,
                    ),
                  );
                },
                child: const Text("Login"),
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(Routes.register);
                },
                child: const Text("Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
