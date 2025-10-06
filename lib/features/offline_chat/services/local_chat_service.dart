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
  static final LocalChatService _instance = LocalChatService._internal();
  factory LocalChatService() => _instance;
  LocalChatService._internal();

  Socket? userSocket;
  Socket? selfSocket;
  ServerSocket? serverSocket;
  final OfflineMessagesStream _offlineMessagesStream = OfflineMessagesStream();
  Stream<OfflineMessage> get messages => _offlineMessagesStream.stream;

  String? serverIp; // to prevent multiple starts

  bool _isClient = false;
  bool _isServer = false;

  bool get isClinet => _isClient;
  bool get isServer => _isServer;

  Socket? get activeSocket {
    if (_isClient) {
      return userSocket;
    } else if (_isServer) {
      return selfSocket;
    }
    return null;
  }

  Future<void> initAudioSend({
    required AudioStreamService audioService,
    required OnAudio onAudio,
  }) async {
    await audioService.initRecorder();
    await audioService.startMicRecording(onAudio);
  }

  Future<void> initAudioReceive({
    required AudioStreamService audioService,
  }) async {
    await audioService.initPlayer();
    await audioService.startReceiving();
  }

  Future<bool> connectToUser({required String serverIp}) async {
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
          final OfflineMessage message = ComProtocol.parseData(data, "1");
          if (!completer.isCompleted && message.type == MessageType.connect) {
            _isClient = true;
            completer.complete(true);
          }
          _offlineMessagesStream.add(message);
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

  bool _isPrivateLocal(String ip) {
    return ip.startsWith('192.168.');
  }

  FutureOr<String> startServer({
    VoidCallback? onClientConnected,
    VoidCallback? onClientDisconnected,
    Duration timeLimit = const Duration(seconds: 5),
  }) async {
    if (serverIp != null) return serverIp!;
    serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, 4040);
    final ipCompleter = Completer<String>();
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        if (addr.type == InternetAddressType.IPv4 &&
            !addr.isLoopback &&
            _isPrivateLocal(addr.address)) {
          log("Server reachable at: ${addr.address}:4040");
          if (!ipCompleter.isCompleted) {
            ipCompleter.complete(addr.address);
            serverIp = addr.address;
          }
        }
      }
    }
    unawaited(_handleConnections(onClientConnected, onClientDisconnected));
    return ipCompleter.future.timeout(
      timeLimit,
      onTimeout: () {
        throw Exception("Failed to get server IP within $timeLimit");
      },
    );
  }

  Future<void> _handleConnections(
    VoidCallback? onClientConnected,
    VoidCallback? onClientDisconnected,
  ) async {
    await for (final socket in serverSocket!) {
      log("New client connected: ${socket.remoteAddress.address}");
      onClientConnected?.call();
      socket.listen(
        (data) {
          final OfflineMessage message = ComProtocol.parseData(data, "2");
          if (message.type == MessageType.connect) {
            socket.add(utf8.encode(ComProtocol.connectMessage));
            _isServer = true;
            selfSocket = socket;
          }
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
    activeSocket?.add(audio);
  }

  Future<void> sendMessage(String message) async {
    log("isClinet: $_isClient, isServer: $_isServer");
    final String signedMessage = ComProtocol.signData(
      type: MessageType.text,
      data: message,
    );
    log("Sending: $signedMessage");
    final Uint8List data = utf8.encode(signedMessage);
    activeSocket?.add(data);
  }

  Future<void> stop() async {
    await userSocket?.close();
    await serverSocket?.close();
    userSocket = null;
    serverSocket = null;
  }
}
