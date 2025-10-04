import 'package:cryptochat/features/shared/utils/routing/routes.dart';
import 'package:flutter/material.dart';

class ModeSelectView extends StatefulWidget {
  const ModeSelectView({super.key});

  @override
  State<ModeSelectView> createState() => _ModeSelectViewState();
}

class _ModeSelectViewState extends State<ModeSelectView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
              ),
              child: Icon(Icons.wifi, size: 40),
            ),
            const SizedBox(height: 16),
            Text(
              "Choose Chat Mode",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..shader = LinearGradient(
                    colors: <Color>[Colors.blue, Colors.purple],
                  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Select how you want to connect",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),
            _buildChatModeButton(
              context,
              text1: "Online Chat",
              text2: "Connect with anyone, anywhere",
              icon: Icons.wifi,
              onClick: () {
                Navigator.of(context).pushNamed(Routes.onlineChat);
              },
            ),
            const SizedBox(height: 12),
            _buildChatModeButton(
              context,
              text1: "Offline Chat",
              text2: "Local network only",
              icon: Icons.wifi_off_rounded,
              onClick: () {
                Navigator.of(context).pushNamed(Routes.offlineChat);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatModeButton(
    BuildContext context, {
    required String text1,
    required String text2,
    required IconData icon,
    required VoidCallback onClick,
  }) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: ElevatedButton(
        onPressed: onClick,
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            Color.fromARGB(255, 32, 32, 32),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(8),
            ),
          ),
        ),
        child: Container(
          margin: EdgeInsets.all(14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 50, 50, 50),
                ),
                child: Icon(
                  icon,
                  color: const Color.fromARGB(255, 0, 105, 191),
                  size: 30,
                ),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text1,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(text2, style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
