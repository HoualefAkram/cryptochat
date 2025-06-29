import 'package:bloc/bloc.dart';
import 'package:cryptochat/features/auth/models/auth_user.dart';
import 'package:cryptochat/features/chat/models/message.dart';
import 'package:cryptochat/features/chat/services/chat_service.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatState());

  Stream<Iterable<Message>> getMessageStream() =>
      ChatService.getMessageStream();

  Future<void> sendMessage({
    required String message,
    required AuthUser owner,
  }) => ChatService.sendMessage(message: message, owner: owner);

  Future<void> initialize() async => ChatService.initialize();
}
