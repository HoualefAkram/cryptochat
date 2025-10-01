import 'dart:developer' show log;
import 'dart:typed_data';

import 'package:cryptochat/features/chat/services/audio_stream_service.dart';
import 'package:cryptochat/features/chat/services/local_chat_service.dart';
import 'package:flutter/material.dart';

class LocalChatView extends StatefulWidget {
  const LocalChatView({super.key});

  @override
  State<LocalChatView> createState() => _LocalChatViewState();
}

class _LocalChatViewState extends State<LocalChatView> {
  LocalChatService chat = LocalChatService();
  AudioStreamService audio = AudioStreamService();

  late TextEditingController serverController;
  late TextEditingController messageController;

  String serverIp = "";

  @override
  void initState() {
    serverController = TextEditingController();
    messageController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    serverController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "SERVER IP: $serverIp",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () async {
                final ip = await chat.startServer(audioService: audio);
                setState(() {
                  serverIp = ip;
                });
              },
              child: const Text("Start Server"),
            ),

            SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: serverController,
                    decoration: InputDecoration(hintText: "Server IP"),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.red),
                  ),
                  onPressed: () async {
                    chat.startClient(serverController.text);
                  },
                  child: const Text("Start Client"),
                ),
              ],
            ),
            SizedBox(height: 80),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(hintText: "Message"),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.red),
                  ),
                  onPressed: () async {
                    chat.clientSendMessage(messageController.text);
                  },
                  child: const Text("Send"),
                ),
              ],
            ),

            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.red),
              ),
              onPressed: () async {
                await audio.initRecorder();
                await audio.startListening((Uint8List audio) {
                  chat.clientSendAudio(audio);
                });
              },
              child: const Text("send audio"),
            ),
          ],
        ),
      ),
    );
  }
}
