import 'package:cryptochat/features/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:cryptochat/features/shared/helpers/loading/loading_screen.dart';
import 'package:cryptochat/features/shared/utils/custom_icon/custom_icon.dart';
import 'package:cryptochat/features/shared/utils/snackbar/generic_snackbar.dart';
import 'package:cryptochat/features/shared/utils/themes/text_style_manager.dart';
import 'package:cryptochat/features/shared/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  late final TextEditingController emailController;

  @override
  void initState() {
    emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, authState) {
        if (authState is AuthLoggedOutState) {
          if (authState.resetEmailSent) {
            ESnackBar.success(context, "Email sent");
            Navigator.of(context).pop();
          }
          if (authState.isLoading) {
            LoadingScreen().show(context: context);
          } else {
            LoadingScreen().hide();
          }
          if (authState.execption != null) {
            ESnackBar.error(context, authState.execption.toString());
          }
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CAppBar(leading: Leading.back, title: Text("Reset password")),
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
              SizedBox(height: 18),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                      AuthResetPasswordEvent(email: emailController.text),
                    );
                  },
                  child: const Text("Send email"),
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
