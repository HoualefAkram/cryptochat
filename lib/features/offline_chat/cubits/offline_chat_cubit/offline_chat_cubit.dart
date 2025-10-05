import 'dart:developer' show log;
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:cryptochat/features/offline_chat/cubits/offline_chat_cubit/offline_chat_exceptions.dart';
import 'package:cryptochat/features/offline_chat/enums/message_type.dart';
import 'package:cryptochat/features/offline_chat/services/audio_stream_service.dart';
import 'package:cryptochat/features/offline_chat/services/local_chat_service.dart';

part 'offline_chat_state.dart';

class OfflineChatCubit extends Cubit<OfflineChatState> {
  OfflineChatCubit()
    : super(OfflineChatNoUserState(serverIp: "None", isMicOpen: false));
  final LocalChatService _localChat = LocalChatService();
  final AudioStreamService _audioStreamService = AudioStreamService();

  Future<void> initAudio() async {
    await _localChat.initAudio(
      audioService: _audioStreamService,
      onAudio: (pcm) {
        if (state.isMicOpen) {
          sendAudio(pcm);
        }
      },
    );
  }

  Future<String> startServer() async {
    final String ip = await _localChat.startServer(
      onClientConnected: () {
        emit(
          OfflineChatConnectedState(serverIp: state.serverIp, isMicOpen: false),
        );
      },
      onClientDisconnected: () {
        emit(
          OfflineChatNoUserState(serverIp: state.serverIp, isMicOpen: false),
        );
      },
    );
    emit(OfflineChatNoUserState(serverIp: ip, isMicOpen: false));
    return ip;
  }

  Future<void> connect(String ip) async {
    final bool connected = await _localChat.connectToUser(serverIp: ip);
    log("connected: $connected");
    if (connected) {
      emit(
        OfflineChatConnectedState(serverIp: state.serverIp, isMicOpen: false),
      );
    } else {
      emit(
        OfflineChatNoUserState(
          serverIp: state.serverIp,
          isMicOpen: false,
          exception: FailedToConnectToServerException("Not connected"),
        ),
      );
    }
  }

  void listenToMessages() {
    _localChat.messages.listen((message) {
      switch (message.type) {
        case MessageType.text:
          log("RECEIVED MESSAGE: ${message.data}");
          break;
        case MessageType.audio:
          log("RECEIVED AUDIO");
          _audioStreamService.onDataReceived(message.noHeader);
          break;
        case MessageType.connect:
          log("CONNECT MESSAGE RECIEVED");
          break;
        default:
          break;
      }
    });
  }

  Future<void> sendMessage(String message) async {
    _localChat.sendMessage(message);
  }

  Future<void> sendAudio(Uint8List pcm) async {
    _localChat.sendAudio(pcm);
  }

  Future<void> toggleAudio() async {
    emit(state.copyWith(isMicOpen: !state.isMicOpen));
  }
}
