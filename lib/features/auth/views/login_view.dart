import 'package:cryptochat/features/auth/blocs/auth_bloc/auth_bloc.dart';

import 'package:cryptochat/features/auth/blocs/obscure_text_cubit/obscure_text_cubit.dart';
import 'package:cryptochat/features/auth/services/auth_exceptions.dart';
import 'package:cryptochat/features/shared/helpers/loading/loading_screen.dart';
import 'package:cryptochat/features/shared/utils/custom_icon/custom_icon.dart';
import 'package:cryptochat/features/shared/utils/routing/routes.dart';
import 'package:cryptochat/features/shared/utils/snackbar/generic_snackbar.dart';
import 'package:cryptochat/features/shared/utils/themes/text_style_manager.dart';
import 'package:cryptochat/features/shared/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

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
              "Failed to login: ${authState.execption.toString()}",
            );
          } else if (authState.execption is AuthInvalidInputException) {
            ESnackBar.error(context, "Invalid input!");
          } else if (authState.execption != null) {
            ESnackBar.error(
              context,
              "Error: ${authState.execption.toString()}",
            );
          }
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 64),
              CustomIcon.build(CIcon.messenger, height: 80, width: 80),
              SizedBox(height: 120),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hint: Text("Email"),
                  labelText: "Email",
                ),
              ),
              SizedBox(height: 12),
              BlocBuilder<ObscureTextCubit, ObscureTextState>(
                builder: (context, obscureTextState) {
                  return TextField(
                    controller: passwordController,
                    obscureText: obscureTextState.obsecureText,
                    decoration: InputDecoration(
                      hint: Text("Password"),
                      labelText: "Password",
                      suffixIcon: IconButton(
                        onPressed: context
                            .read<ObscureTextCubit>()
                            .toggleObscureText,
                        icon: Icon(
                          obscureTextState.obsecureText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 12),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                      AuthLoginEvent(
                        email: emailController.text,
                        password: passwordController.text,
                      ),
                    );
                  },
                  child: Text("Log in"),
                ),
              ),
              SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(Routes.resetPassword);
                },
                child: Text("Forgot password?"),
              ),
              const Spacer(),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(Routes.register);
                  },
                  child: const Text("Create new account"),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Houalef Akram",
                style: TextStyleManager.large(
                  bold: true,
                  color: Colors.grey.withAlpha(90),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
