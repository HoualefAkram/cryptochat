part of 'offline_chat_cubit.dart';

class OfflineChatState {
  final String serverIp;
  final Exception? exception;
  const OfflineChatState({required this.serverIp, this.exception});

  OfflineChatState copyWith({String? serverIp, Exception? exception}) =>
      OfflineChatState(
        serverIp: serverIp ?? this.serverIp,
        exception: exception,
      );
}

final class OfflineChatNoUserState extends OfflineChatState {
  OfflineChatNoUserState({required super.serverIp, super.exception});

  @override
  OfflineChatState copyWith({String? serverIp, Exception? exception}) =>
      OfflineChatNoUserState(
        serverIp: serverIp ?? super.serverIp,
        exception: exception,
      );
}

final class OfflineChatConnectedState extends OfflineChatState {
  OfflineChatConnectedState({required super.serverIp, super.exception});

  @override
  OfflineChatState copyWith({String? serverIp, Exception? exception}) =>
      OfflineChatConnectedState(
        serverIp: serverIp ?? super.serverIp,
        exception: exception,
      );
}
