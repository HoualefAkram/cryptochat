part of 'chat_cubit.dart';

class ChatState extends Equatable {
  final bool hasText;

  const ChatState({required this.hasText});

  @override
  List<Object?> get props => [hasText];
}
