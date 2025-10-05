part of 'offline_chat_cubit.dart';

sealed class OfflineChatState {
  final String serverIp;
  const OfflineChatState({required this.serverIp});
}

final class OfflineChatNoUserState extends OfflineChatState {
  OfflineChatNoUserState({required super.serverIp});
}

final class OfflineChatConnectedState extends OfflineChatState {
  OfflineChatConnectedState({required super.serverIp});
}
