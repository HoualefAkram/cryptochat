import 'package:bloc/bloc.dart';
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
    );
    emit(OfflineChatNoUserState(serverIp: ip));
    return ip;
  }

  Future<void> connect(String ip) async {
    _localChat.connectToUser(ip);
    // TODO: REMOVE
    emit(OfflineChatConnectedState(serverIp: ip));
  }

  Future<void> sendMessage(String message) async {
    _localChat.sendMessage(message);
  }
}
