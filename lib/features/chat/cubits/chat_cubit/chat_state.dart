part of 'chat_cubit.dart';

class ChatState extends Equatable {
  final bool hasText;
  final bool isFABvisible;

  const ChatState({required this.hasText, required this.isFABvisible});

  ChatState copyWith({bool? hasText, bool? isFABvisible}) {
    return ChatState(
      hasText: hasText ?? this.hasText,
      isFABvisible: isFABvisible ?? this.isFABvisible,
    );
  }

  @override
  List<Object?> get props => [hasText, isFABvisible];
}
