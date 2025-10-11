import 'dart:async';
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

  Socket? _userSocket;
  Socket? _selfSocket;
  ServerSocket? _serverSocket;
  final OfflineMessagesStream _offlineMessagesStream = OfflineMessagesStream();
  Stream<OfflineMessage> get messages => _offlineMessagesStream.stream;
  String? get selfIp => _selfServerIp;

  String? _selfServerIp; // to prevent multiple starts

  bool _isClient = false;
  bool _isServer = false;

  bool get isClinet => _isClient;
  bool get isServer => _isServer;

  Socket? get activeSocket {
    if (_isClient) {
      return _userSocket;
    } else if (_isServer) {
      return _selfSocket;
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

  Future<void> stopRecordingAudio({
    required AudioStreamService audioService,
  }) async {
    audioService.stopListening();
  }

  Future<void> stopReceivingAudio({
    required AudioStreamService audioService,
  }) async {
    audioService.stopReceiving();
  }

  Future<bool> connectToUser({required String ip}) async {
    final completer = Completer<bool>();

    try {
      _userSocket = await Socket.connect(
        ip,
        4040,
        timeout: const Duration(seconds: 3),
      );

      log("Connecting to: ${_userSocket!.remoteAddress.address}");

      _userSocket!.add(
        ComProtocol.encode(
          type: MessageType.connect,
          owner: _selfServerIp!,
          data: null,
        ),
      );

      _userSocket!.listen(
        (data) {
          final OfflineMessage message = ComProtocol.decode(data);
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
    if (_selfServerIp != null) return _selfServerIp!;
    _serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, 4040);
    final ipCompleter = Completer<String>();
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        if (addr.type == InternetAddressType.IPv4 &&
            !addr.isLoopback &&
            _isPrivateLocal(addr.address)) {
          log("Server reachable at: ${addr.address}:4040");
          if (!ipCompleter.isCompleted) {
            ipCompleter.complete(addr.address);
            _selfServerIp = addr.address;
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
    await for (final socket in _serverSocket!) {
      log("New client connected: ${socket.remoteAddress.address}");
      onClientConnected?.call();
      socket.listen(
        (data) {
          final OfflineMessage message = ComProtocol.decode(data);
          if (message.type == MessageType.connect) {
            socket.add(
              ComProtocol.encode(
                type: MessageType.connect,
                owner: _selfServerIp!,
                data: null,
              ),
            );
            _isServer = true;
            _selfSocket = socket;
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
    final data = ComProtocol.encode(
      type: MessageType.audio,
      owner: _selfServerIp!,
      data: audio,
    );
    activeSocket?.add(data);
  }

  Future<void> sendMessage(String message) async {
    log("isClinet: $_isClient, isServer: $_isServer");
    final Uint8List data = ComProtocol.encode(
      type: MessageType.text,
      owner: _selfServerIp!,
      data: message,
    );
    activeSocket?.add(data);
  }

  Future<void> startVoiceConnection() async {
    final Uint8List data = ComProtocol.encode(
      type: MessageType.requestCall,
      owner: _selfServerIp!,
      data: null,
    );
    activeSocket?.add(data);
  }

  Future<void> notifyRinging() async {
    final Uint8List data = ComProtocol.encode(
      type: MessageType.ringing,
      owner: _selfServerIp!,
      data: null,
    );
    activeSocket?.add(data);
  }

  Future<void> refuseCall() async {
    final Uint8List data = ComProtocol.encode(
      type: MessageType.refuseCall,
      owner: _selfServerIp!,
      data: null,
    );
    activeSocket?.add(data);
  }

  Future<void> acceptCall() async {
    final Uint8List data = ComProtocol.encode(
      type: MessageType.acceptCall,
      owner: _selfServerIp!,
      data: null,
    );
    activeSocket?.add(data);
  }

  Future<void> endCall() async {
    final Uint8List data = ComProtocol.encode(
      type: MessageType.endCall,
      owner: _selfServerIp!,
      data: null,
    );
    activeSocket?.add(data);
  }

  Future<void> stop() async {
    await _userSocket?.close();
    await _serverSocket?.close();
    _userSocket = null;
    _serverSocket = null;
  }
}
