import 'package:bloc/bloc.dart';
import 'package:cryptochat/features/auth/models/auth_user.dart';
import 'package:cryptochat/features/chat/models/message.dart';
import 'package:cryptochat/features/chat/services/chat_service.dart';
import 'package:equatable/equatable.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatState(hasText: false));

  Stream<Iterable<Message>> getMessageStream() =>
      ChatService.getMessageStream();

  void setTextState(String text) {
    emit(ChatState(hasText: text.isNotEmpty));
  }

  Future<void> sendMessage({
    required String message,
    required AuthUser owner,
  }) async {
    await ChatService.sendMessage(message: message, owner: owner);
    emit(ChatState(hasText: false));
  }
}
