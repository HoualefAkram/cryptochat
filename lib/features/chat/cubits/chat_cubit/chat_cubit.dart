import 'package:bloc/bloc.dart';
import 'package:cryptochat/features/chat/models/message.dart';
import 'package:cryptochat/features/chat/models/seed.dart';
import 'package:cryptochat/features/chat/services/chat_service.dart';
import 'package:equatable/equatable.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit()
    : super(
        ChatState(
          hasText: false,
          isFABvisible: false,
          readSeed: null,
          writeSeed: null,
        ),
      );

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

  Future<void> sendMessage({required Message message}) async {
    await ChatService.sendMessage(
      message: message.encode(state.writeSeed).text,
      owner: message.owner,
    );
    emit(state.copyWith(hasText: false));
  }

  void setSeed(Seed seed) => emit(
    ChatState(
      hasText: state.hasText,
      isFABvisible: state.isFABvisible,
      readSeed: seed.read,
      writeSeed: seed.write,
    ),
  );
}
