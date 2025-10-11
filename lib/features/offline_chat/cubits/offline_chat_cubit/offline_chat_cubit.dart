import 'dart:async';
import 'dart:developer' as dev show log;
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:cryptochat/features/offline_chat/cubits/offline_chat_cubit/offline_chat_exceptions.dart';
import 'package:cryptochat/features/offline_chat/enums/call_status.dart';
import 'package:cryptochat/features/offline_chat/enums/message_type.dart';
import 'package:cryptochat/features/offline_chat/models/offline_message.dart';
import 'package:cryptochat/features/offline_chat/services/audio_stream_service.dart';
import 'package:cryptochat/features/offline_chat/services/local_chat_service.dart';

part 'offline_chat_state.dart';

class OfflineChatCubit extends Cubit<OfflineChatState> {
  OfflineChatCubit()
    : super(OfflineChatNoUserState(serverIp: "None", isMicOpen: true));
  final LocalChatService _localChat = LocalChatService();
  final AudioStreamService _audioStreamService = AudioStreamService();

  StreamSubscription<OfflineMessage>? _messageSub;

  final StreamController<List<OfflineMessage>> _offlineMessagesController =
      StreamController<List<OfflineMessage>>.broadcast();

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

  Future<void> stopAudio() async {
    await _localChat.stopReceivingAudio(audioService: _audioStreamService);
    await _localChat.stopRecordingAudio(audioService: _audioStreamService);
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
    final bool connected = await _localChat.connectToUser(ip: ip);
    dev.log("connected: $connected");
    if (connected) {
      emit(
        OfflineChatConnectedState(serverIp: state.serverIp, isMicOpen: false),
      );
    } else {
      emit(
        OfflineChatNoUserState(
          serverIp: state.serverIp,
          isMicOpen: false,
          exception: FailedToConnectToServerException(
            "Failed to connect to server",
          ),
        ),
      );
    }
  }

  void initMessages() {
    final bool hasListener = _messageSub != null;
    _offlineMessagesController.add(_currentMessages); // init messages
    if (hasListener) return;
    _messageSub = _localChat.messages.listen((message) {
      switch (message.type) {
        case MessageType.text:
          _currentMessages.add(message);
          _offlineMessagesController.add(_currentMessages);
          break;
        case MessageType.audio:
          _audioStreamService.onDataReceived(
            Uint8List.fromList(message.data.cast<int>()),
          );
          break;
        case MessageType.requestCall:
          dev.log("RECEIVING CALL FROM: ${message.owner}");
          emit(
            OfflineChatCallState(
              serverIp: state.serverIp,
              isMicOpen: state.isMicOpen,
              callStatus: CallStatus.incoming,
            ),
          );
          _localChat.notifyRinging();
          break;
        case MessageType.ringing:
          // Change text to ringing
          dev.log("RINGING...");
          emit(
            OfflineChatCallState(
              serverIp: state.serverIp,
              isMicOpen: state.isMicOpen,
              callStatus: CallStatus.ringing,
            ),
          );
          break;
        case MessageType.connect:
          dev.log("CONNECT MESSAGE RECEIVED");
          break;
        case MessageType.refuseCall:
          emit(
            OfflineChatConnectedState(
              serverIp: state.serverIp,
              isMicOpen: state.isMicOpen,
            ),
          );
          break;
        case MessageType.acceptCall:
          dev.log("CALL ACCEPTED");
          emit(
            OfflineChatCallState(
              serverIp: state.serverIp,
              isMicOpen: state.isMicOpen,
              callStatus: CallStatus.live,
            ),
          );
          initAudio(); // OPEN MICROPHONE / RECEIVER
          break;
        case MessageType.endCall:
          dev.log("CALL ENDED BY OTHER USER");
          emit(
            OfflineChatConnectedState(
              serverIp: state.serverIp,
              isMicOpen: state.isMicOpen,
            ),
          );
          stopAudio();
          break;

        case MessageType.cancelRequestCall:
          emit(
            OfflineChatConnectedState(
              serverIp: state.serverIp,
              isMicOpen: state.isMicOpen,
            ),
          );
          break;
        default:
          break;
      }
    });
  }

  Future<void> sendMessage(String message) async {
    _currentMessages.add(
      OfflineMessage(
        type: MessageType.text,
        data: message,
        owner: _localChat.selfIp!,
      ),
    );
    _offlineMessagesController.add(_currentMessages);
    _localChat.sendMessage(message);
  }

  Future<void> sendAudio(Uint8List pcm) async {
    _localChat.sendAudio(pcm);
  }

  Future<void> toggleMicrophone() async {
    emit(state.copyWith(isMicOpen: !state.isMicOpen));
  }

  Future<void> startVoiceConnection() async {
    _localChat.startVoiceConnection();
    emit(
      OfflineChatCallState(
        serverIp: state.serverIp,
        isMicOpen: state.isMicOpen,
        callStatus: CallStatus.connecting,
      ),
    );
    dev.log("CALLING...");
  }

  Future<void> refuseCall() async {
    _localChat.refuseCall();
    emit(
      OfflineChatConnectedState(
        serverIp: state.serverIp,
        isMicOpen: state.isMicOpen,
      ),
    );
  }

  Future<void> acceptCall() async {
    _localChat.acceptCall();
    emit(
      OfflineChatCallState(
        serverIp: state.serverIp,
        isMicOpen: state.isMicOpen,
        callStatus: CallStatus.live,
      ),
    );
    initAudio(); // OPEN MICROPHONE / RECEIVER
  }

  Future<void> endCall() async {
    _localChat.endCall();
    emit(
      OfflineChatConnectedState(
        serverIp: state.serverIp,
        isMicOpen: state.isMicOpen,
      ),
    );

    stopAudio(); // STOP MICROPHONE / RECEIVER
  }

  Future<void> cancelCallRequest() async {
    _localChat.cancelCallRequest();
    emit(
      OfflineChatConnectedState(
        serverIp: state.serverIp,
        isMicOpen: state.isMicOpen,
      ),
    );
  }

  bool isOwner(OfflineMessage msg) => _localChat.selfIp == msg.owner;
}
