import 'dart:async';
import 'dart:developer' show log;
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:cryptochat/features/offline_chat/cubits/offline_chat_cubit/offline_chat_exceptions.dart';
import 'package:cryptochat/features/offline_chat/enums/message_type.dart';
import 'package:cryptochat/features/offline_chat/models/offline_message.dart';
import 'package:cryptochat/features/offline_chat/services/audio_stream_service.dart';
import 'package:cryptochat/features/offline_chat/services/local_chat_service.dart';

part 'offline_chat_state.dart';

class OfflineChatCubit extends Cubit<OfflineChatState> {
  OfflineChatCubit()
    : super(OfflineChatNoUserState(serverIp: "None", isMicOpen: false));
  final LocalChatService _localChat = LocalChatService();
  final AudioStreamService _audioStreamService = AudioStreamService();

  final StreamController<List<OfflineMessage>> _offlineMessagesController =
      StreamController();

  final List<OfflineMessage> _currentMessages = List.empty(growable: true);

  Stream<List<OfflineMessage>> getMessagesStream() =>
      _offlineMessagesController.stream;

  Future<void> initAudio() async {
    _localChat.initAudioReceive(audioService: _audioStreamService);
    await _localChat.initAudioSend(
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
          _currentMessages.add(message);
          _offlineMessagesController.add(_currentMessages);
          break;
        case MessageType.audio:
          _audioStreamService.onDataReceived(message.rawData);
          break;
        case MessageType.connect:
          log("CONNECT MESSAGE RECEIVED");
          break;
        default:
          break;
      }
    });
  }

  Future<void> sendMessage(String message) async {
    _currentMessages.add(OfflineMessage.fromString(message, getId()));
    _offlineMessagesController.add(_currentMessages);
    _localChat.sendMessage(message);
  }

  Future<void> sendAudio(Uint8List pcm) async {
    _localChat.sendAudio(pcm);
  }

  Future<void> toggleAudio() async {
    emit(state.copyWith(isMicOpen: !state.isMicOpen));
  }

  bool isOwner(OfflineMessage msg) {
    final String owner = msg.owner;
    if (_localChat.isServer && owner == "1") return true;
    if (_localChat.isClinet && owner == "2") return true;
    return false;
  }

  String getId() {
    if (_localChat.isServer) return "1";
    return "2";
  }
}
