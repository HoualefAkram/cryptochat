import 'package:bloc/bloc.dart';
import 'package:cryptochat/features/auth/models/auth_user.dart';
import 'package:cryptochat/features/chat/models/message.dart';
import 'package:cryptochat/features/chat/services/chat_service.dart';
import 'package:equatable/equatable.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatState(hasText: false, isFABvisible: false));

  Stream<Iterable<Message>> getMessageStream() =>
      ChatService.getMessageStream();

  void setTextState(String text) {
    final bool hasText = text.isNotEmpty;
    if (state.hasText == hasText) return;
    emit(state.copyWith(hasText: hasText));
  }

  void setFABVisibility(bool isVisible) {
    if (state.isFABvisible == isVisible) return;
    emit(state.copyWith(isFABvisible: isVisible));
  }

  Future<void> sendMessage({
    required String message,
    required AuthUser owner,
  }) async {
    await ChatService.sendMessage(message: message.trim(), owner: owner);
    emit(ChatState(hasText: false, isFABvisible: state.isFABvisible));
  }
}
