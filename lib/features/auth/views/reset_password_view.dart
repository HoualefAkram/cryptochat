import 'package:cryptochat/features/shared/utils/custom_icon/custom_icon.dart';
import 'package:cryptochat/features/shared/utils/themes/text_style_manager.dart';
import 'package:cryptochat/features/shared/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CAppBar(leading: Leading.back),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 64),
            CustomIcon.build(CIcon.messenger, height: 80, width: 80),
            SizedBox(height: 120),
            TextField(
              // controller: emailController,
              decoration: InputDecoration(
                hint: Text("Email"),
                labelText: "Email",
              ),
            ),
            SizedBox(height: 12),
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("Send email"),
              ),
            ),
            const Spacer(),
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
    );
  }
}
