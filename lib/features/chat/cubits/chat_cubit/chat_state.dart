part of 'chat_cubit.dart';

class ChatState extends Equatable {
  final bool hasText;
  final Seed seed;
  final bool isFABvisible;

  const ChatState({
    required this.hasText,
    required this.isFABvisible,
    required this.seed,
  });

  ChatState copyWith({bool? hasText, bool? isFABvisible, Seed? seed}) {
    return ChatState(
      hasText: hasText ?? this.hasText,
      isFABvisible: isFABvisible ?? this.isFABvisible,
      seed: seed ?? this.seed,
    );
  }

  @override
  List<Object?> get props => [hasText, isFABvisible, seed];
}
