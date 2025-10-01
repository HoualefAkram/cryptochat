import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cryptochat/features/chat/services/audio_stream_service.dart';

class LocalChatService {
  Socket? clientSocket;
  ServerSocket? serverSocket;

  Future<void> startClient(String serverIp) async {
    clientSocket = await Socket.connect(serverIp, 4040);
    log("Connected to: ${clientSocket!.remoteAddress.address}");

    clientSocket!.add(utf8.encode("Hello from client!"));
    clientSocket!.listen((data) {
      log("Reply: ${utf8.decode(data)}");
    });
  }

  Future<String> startServer({
    required AudioStreamService audioService,
    Duration timeLimit = const Duration(seconds: 5),
  }) async {
    serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, 4040);
    log(
      "Server running on: ${serverSocket!.address.address}:${serverSocket!.port}",
    );

    // Will complete with the first non-loopback IPv4
    final ipCompleter = Completer<String>();

    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
          log("Server reachable at: ${addr.address}:4040");
          if (!ipCompleter.isCompleted) {
            ipCompleter.complete(addr.address);
          }
        }
      }
    }

    // Accept clients asynchronously (don’t block returning the IP)
    unawaited(_handleConnections(audioService));

    return ipCompleter.future.timeout(
      timeLimit,
      onTimeout: () {
        throw Exception("Failed to get server IP within $timeLimit");
      },
    );
  }

  Future<void> _handleConnections(AudioStreamService audioService) async {
    await audioService.initPlayer();
    await audioService.startReceiving();
    await for (final socket in serverSocket!) {
      log("New client connected: ${socket.remoteAddress.address}");
      socket.listen(
        (data) {
          log("Received: $data");
          audioService.onDataReceived(data);
        },
        onDone: () {
          log("Client disconnected: ${socket.remoteAddress.address}");
        },
      );
    }
  }

  void clientSendAudio(List<int> audio) {
    clientSocket?.add(audio);
  }

  void _sendMessage(Socket socket, String message) {
    socket.add(utf8.encode(message));
    log("Server sent: $message");
  }

  void clientSendMessage(String message) {
    _sendMessage(clientSocket!, message);
  }

  Future<void> stop() async {
    await clientSocket?.close();
    await serverSocket?.close();
  }
}
