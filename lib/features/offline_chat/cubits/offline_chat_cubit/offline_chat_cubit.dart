import 'dart:developer' show log;

import 'package:bloc/bloc.dart';
import 'package:cryptochat/features/offline_chat/cubits/offline_chat_cubit/offline_chat_exceptions.dart';
import 'package:cryptochat/features/offline_chat/services/audio_stream_service.dart';
import 'package:cryptochat/features/offline_chat/services/local_chat_service.dart';

part 'offline_chat_state.dart';

class OfflineChatCubit extends Cubit<OfflineChatState> {
  OfflineChatCubit() : super(OfflineChatNoUserState(serverIp: "None"));
  final LocalChatService _localChat = LocalChatService();
  final AudioStreamService _audioStreamService = AudioStreamService();

  Future<String> startServer() async {
    final String ip = await _localChat.startServer(
      audioService: _audioStreamService,
      onClientConnected: () {
        emit(OfflineChatConnectedState(serverIp: state.serverIp));
      },
      onClientDisconnected: () {
        emit(OfflineChatNoUserState(serverIp: state.serverIp));
      },
    );
    emit(OfflineChatNoUserState(serverIp: ip));
    return ip;
  }

  Future<void> connect(String ip) async {
    final bool connected = await _localChat.connectToUser(
      serverIp: ip,
      audioService: _audioStreamService,
    );
    log("connected: $connected");
    if (connected) {
      emit(OfflineChatConnectedState(serverIp: state.serverIp));
    } else {
      emit(
        OfflineChatNoUserState(
          serverIp: state.serverIp,
          exception: FailedToConnectToServerException("Not connected"),
        ),
      );
    }
  }

  void listenToMessages() {
    _localChat.messages.listen((message) {
      log("MESSAGE RECEIVED: ${message.data}");
    });
  }

  Future<void> sendMessage(String message) async {
    _localChat.sendMessage(message);
  }
}
