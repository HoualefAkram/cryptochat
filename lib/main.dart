import 'package:cryptochat/features/chat/services/chat_service.dart';
import 'package:cryptochat/features/chat/views/chat_view.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ChatService.initialize();
  runApp(
    MaterialApp(
      title: 'Akram',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Main(),
    ),
  );
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    //TODO: Add Login
    return const ChatView();
  }
}
