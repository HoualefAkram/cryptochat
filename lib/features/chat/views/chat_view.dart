import 'package:cryptochat/features/chat/models/message.dart';
import 'package:cryptochat/features/chat/services/chat_service.dart';
import 'package:flutter/material.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Messenger ta3 ouedknis")),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                ChatService.sendMessage(message: "Akran message");
              },
              child: const Text("Send message"),
            ),

            Expanded(
              child: StreamBuilder(
                stream: ChatService.getMessageStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData && snapshot.data == null) {
                    return const Text("No data");
                  }
                  final List<Message> data = snapshot.data!.toList();
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final Message msg = data[index];
                      return Text("${msg.owner} : ${msg.message}");
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
