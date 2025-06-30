import 'package:cryptochat/features/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:cryptochat/features/auth/blocs/obscure_text_cubit/obscure_text_cubit.dart';
import 'package:cryptochat/features/shared/utils/custom_icon/custom_icon.dart';
import 'package:cryptochat/features/shared/utils/snackbar/generic_snackbar.dart';
import 'package:cryptochat/features/shared/utils/themes/text_style_manager.dart';
import 'package:cryptochat/features/shared/widgets/app_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController nameController;

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
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CAppBar(leading: Leading.back, title: Text("New account")),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 64),
              CustomIcon.build(CIcon.messenger, height: 80, width: 80),
              SizedBox(height: 120),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hint: Text("Name"),
                  label: Text("Name"),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hint: Text("Email"),
                  label: Text("Email"),
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
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                      AuthRegisterEvent(
                        email: emailController.text,
                        password: passwordController.text,
                        name: nameController.text,
                      ),
                    );
                  },
                  child: const Text("Create account"),
                ),
              ),
              const Spacer(),
              Text(
                "Houalef Akram",
                style: TextStyleManager.medium(
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
