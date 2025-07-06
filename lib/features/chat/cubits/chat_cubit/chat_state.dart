part of 'chat_cubit.dart';

class ChatState extends Equatable {
  final bool hasText;
  final int? readSeed;
  final int? writeSeed;
  final bool isFABvisible;

  const ChatState({
    required this.hasText,
    required this.isFABvisible,
    required this.readSeed,
    required this.writeSeed,
  });

  ChatState copyWith({
    bool? hasText,
    bool? isFABvisible,
    int? readSeed,
    int? writeSeed,
  }) {
    return ChatState(
      hasText: hasText ?? this.hasText,
      isFABvisible: isFABvisible ?? this.isFABvisible,
      readSeed: readSeed ?? this.readSeed,
      writeSeed: writeSeed ?? this.writeSeed,
    );
  }

  @override
  List<Object?> get props => [hasText, isFABvisible, readSeed, writeSeed];
}
