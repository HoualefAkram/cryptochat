part of 'online_chat_cubit.dart';

class OnlineChatState extends Equatable {
  final bool hasText;
  final CryptoSeed seed;
  final bool isFABvisible;

  const OnlineChatState({
    required this.hasText,
    required this.isFABvisible,
    required this.seed,
  });

  OnlineChatState copyWith({
    bool? hasText,
    bool? isFABvisible,
    CryptoSeed? seed,
  }) {
    return OnlineChatState(
      hasText: hasText ?? this.hasText,
      isFABvisible: isFABvisible ?? this.isFABvisible,
      seed: seed ?? this.seed,
    );
  }

  @override
  List<Object?> get props => [hasText, isFABvisible, seed];
}
