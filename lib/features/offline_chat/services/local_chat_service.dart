import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cryptochat/features/offline_chat/enums/message_type.dart';
import 'package:cryptochat/features/offline_chat/models/offline_message.dart';
import 'package:cryptochat/features/offline_chat/services/audio_stream_service.dart';
import 'package:cryptochat/features/offline_chat/services/communication_protocol_service.dart';
import 'package:cryptochat/features/offline_chat/services/offline_messages_stream.dart';

import 'package:flutter/material.dart';

class LocalChatService {
  Socket? userSocket;
  Socket? selfSocket;
  ServerSocket? serverSocket;
  final OfflineMessagesStream _offlineMessagesStream = OfflineMessagesStream();
  Stream<OfflineMessage> get messages => _offlineMessagesStream.stream;

  bool isClient = false;
  bool isServer = false;

  Future<bool> connectToUser({
    required String serverIp,
    required AudioStreamService audioService,
  }) async {
    final completer = Completer<bool>();

    try {
      userSocket = await Socket.connect(
        serverIp,
        4040,
        timeout: const Duration(seconds: 3),
      );

      log("Connecting to: ${userSocket!.remoteAddress.address}");

      userSocket!.add(utf8.encode(ComProtocol.connectMessage));

      userSocket!.listen(
        (data) {
          final OfflineMessage message = ComProtocol.parseData(data);
          if (!completer.isCompleted && message.type == MessageType.connect) {
            isClient = true;
            completer.complete(true);
          }
          _offlineMessagesStream.add(message);
          // else if (message.type == MessageType.audio) {
          //   audioService.onDataReceived(data);
          // } else if (message.type == MessageType.text) {
          //   log("isClient: $isClient, isServer: $isServer");
          //   log("RECEIVED TEXT: ${message.data}");
          // }
        },
        onError: (error) {
          if (!completer.isCompleted) {
            completer.complete(false);
          }
        },
        onDone: () {
          if (!completer.isCompleted) {
            completer.complete(false);
          }
        },
        cancelOnError: true,
      );

      return await completer.future.timeout(
        const Duration(seconds: 4),
        onTimeout: () {
          log("Connection timeout");
          if (!completer.isCompleted) {
            completer.complete(false);
          }
          return false;
        },
      );
    } catch (e) {
      log("Connection error: $e");
      completer.complete(false);
      return false;
    }
  }

  Future<String> startServer({
    required AudioStreamService audioService,
    VoidCallback? onClientConnected,
    VoidCallback? onClientDisconnected,
    Duration timeLimit = const Duration(seconds: 5),
  }) async {
    serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, 4040);
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
    unawaited(
      _handleConnections(audioService, onClientConnected, onClientDisconnected),
    );
    return ipCompleter.future.timeout(
      timeLimit,
      onTimeout: () {
        throw Exception("Failed to get server IP within $timeLimit");
      },
    );
  }

  Future<void> _handleConnections(
    AudioStreamService audioService,
    VoidCallback? onClientConnected,
    VoidCallback? onClientDisconnected,
  ) async {
    await audioService.initPlayer();
    await audioService.startReceiving();

    await for (final socket in serverSocket!) {
      log("New client connected: ${socket.remoteAddress.address}");
      onClientConnected?.call();
      socket.listen(
        (data) {
          final OfflineMessage message = ComProtocol.parseData(data);
          // if (message.type == MessageType.audio) {
          //   audioService.onDataReceived(data);
          // } else
          if (message.type == MessageType.connect) {
            socket.add(utf8.encode(ComProtocol.connectMessage));
            isServer = true;
            selfSocket = socket;
          }
          // else if (message.type == MessageType.text) {
          //   log("isClient: $isClient, isServer: $isServer");
          //   log("RECEIVED TEXT: ${message.data}");
          // }
          _offlineMessagesStream.add(message);
        },
        onDone: () {
          log("Client disconnected: ${socket.remoteAddress.address}");
          onClientDisconnected?.call();
        },
      );
    }
  }

  Future<void> sendAudio(List<int> audio) async {
    userSocket?.add(audio);
  }

  Future<void> sendMessage(String message) async {
    log("isClinet: $isClient, isServer: $isServer");
    final String signedMessage = ComProtocol.signMessage(
      type: MessageType.text,
      message: message,
    );
    log("Sending: $signedMessage");
    final Uint8List data = utf8.encode(signedMessage);
    if (isClient) {
      userSocket?.add(data);
    } else if (isServer) {
      selfSocket?.add(data);
    }
  }

  Future<void> stop() async {
    await userSocket?.close();
    await serverSocket?.close();
    userSocket = null;
    serverSocket = null;
  }
}
