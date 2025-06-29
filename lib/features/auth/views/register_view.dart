import 'package:cryptochat/features/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:cryptochat/features/shared/utils/snackbar/generic_snackbar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController nameController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    nameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, authState) {
        if (authState is AuthLoggedOutState) {
          if (authState.registered) {
            ESnackBar.success(context, "Register done!");
            Navigator.of(context).pop();
          }
        }
        if (authState is AuthLoggedOutState) {
          if (authState.execption != null) {
            ESnackBar.error(
              context,
              "Failed to register: ${authState.execption.toString()}",
            );
          }
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(hint: Text("Name")),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(hint: Text("Email")),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(hint: Text("Password")),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                    AuthRegisterEvent(
                      email: emailController.text,
                      password: passwordController.text,
                      name: nameController.text,
                    ),
                  );
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
