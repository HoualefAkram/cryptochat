import 'package:bloc/bloc.dart';
import 'package:cryptochat/features/online_chat/models/online_message.dart';
import 'package:cryptochat/features/online_chat/models/crypto_seed.dart';
import 'package:cryptochat/features/online_chat/services/online_chat_service.dart';
import 'package:equatable/equatable.dart';

part 'online_chat_state.dart';

class OnlineChatCubit extends Cubit<OnlineChatState> {
  OnlineChatCubit()
    : super(
        OnlineChatState(
          hasText: false,
          isFABvisible: false,
          seed: CryptoSeed(read: null, write: null),
        ),
      );

  Stream<Iterable<OnlineMessage>> getMessageStream() =>
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

  Future<void> sendMessage({required OnlineMessage message}) async {
    await ChatService.sendMessage(
      message: message.encode(state.seed.write).text,
      owner: message.owner,
    );
    emit(state.copyWith(hasText: false));
  }

  void setSeed(CryptoSeed seed) => emit(state.copyWith(seed: seed));
}
