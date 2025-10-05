import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cryptochat/features/offline_chat/enums/message_type.dart';
import 'package:cryptochat/features/offline_chat/models/offline_message.dart';
import 'package:cryptochat/features/offline_chat/services/audio_stream_service.dart';
import 'package:cryptochat/features/offline_chat/services/communication_protocol_service.dart';

class LocalChatService {
  Socket? userSocket;
  ServerSocket? selfSocket;

  bool isClient = false;
  bool isServer = false;

  Future<void> connectToUser(String serverIp) async {
    userSocket = await Socket.connect(serverIp, 4040);
    log("Connected to: ${userSocket!.remoteAddress.address}");
    userSocket!.add(utf8.encode(ComProtocol.connectMessage));
    userSocket!.listen((data) {
      // data from other user
      final OfflineMessage message = ComProtocol.parseData(data);
      log("from other user: ${message.data}");
      if (message.type == MessageType.connect) {
        isClient = true;
      }
    });
  }

  Future<String> startServer({
    required AudioStreamService audioService,
    Duration timeLimit = const Duration(seconds: 5),
  }) async {
    selfSocket = await ServerSocket.bind(InternetAddress.anyIPv4, 4040);
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
    await for (final socket in selfSocket!) {
      log("New client connected: ${socket.remoteAddress.address}");
      socket.listen(
        (data) {
          final OfflineMessage message = ComProtocol.parseData(data);
          if (message.type == MessageType.audio) {
            audioService.onDataReceived(data);
          } else if (message.type == MessageType.connect) {
            socket.add(utf8.encode(ComProtocol.connectMessage));
            isServer = true;
          } else if (message.type == MessageType.text) {
            log("RECEIVED TEXT: ${message.data}");
          }
        },
        onDone: () {
          log("Client disconnected: ${socket.remoteAddress.address}");
        },
      );
    }
  }

  Future<void> sendAudio(List<int> audio) async {
    userSocket?.add(audio);
  }

  Future<void> sendMessage(String message) async {
    log("isClinet: $isClient, isServer; $isServer");
    final String signedMessage = ComProtocol.signMessage(
      type: MessageType.text,
      message: message,
    );
    log("Sending: $signedMessage");
    final Uint8List data = utf8.encode(signedMessage);
    if (isClient) {
      userSocket?.add(data);
    } else if (isServer) {
      await for (final socket in selfSocket!) {
        socket.add(data);
      }
    }
  }

  Future<void> stop() async {
    await userSocket?.close();
    await selfSocket?.close();
    userSocket = null;
    selfSocket = null;
  }
}
