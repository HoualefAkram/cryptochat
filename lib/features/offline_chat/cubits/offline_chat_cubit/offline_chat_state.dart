part of 'offline_chat_cubit.dart';

class OfflineChatState {
  final String serverIp;
  final bool isMicOpen;
  final Exception? exception;

  const OfflineChatState({
    required this.serverIp,
    required this.isMicOpen,
    this.exception,
  });

  OfflineChatState copyWith({
    String? serverIp,
    bool? isMicOpen,
    bool receivedCall = false,
    Exception? exception,
  }) => OfflineChatState(
    serverIp: serverIp ?? this.serverIp,
    isMicOpen: isMicOpen ?? this.isMicOpen,
    exception: exception,
  );
}

final class OfflineChatNoUserState extends OfflineChatState {
  OfflineChatNoUserState({
    required super.serverIp,
    required super.isMicOpen,
    super.exception,
  });

  @override
  OfflineChatState copyWith({
    String? serverIp,
    bool? isMicOpen,
    bool receivedCall = false,
    Exception? exception,
  }) => OfflineChatNoUserState(
    serverIp: serverIp ?? super.serverIp,
    isMicOpen: isMicOpen ?? super.isMicOpen,
    exception: exception,
  );
}

final class OfflineChatConnectedState extends OfflineChatState {
  OfflineChatConnectedState({
    required super.isMicOpen,
    required super.serverIp,
    super.exception,
  });

  @override
  OfflineChatState copyWith({
    String? serverIp,
    bool? isMicOpen,
    bool receivedCall = false,
    Exception? exception,
  }) => OfflineChatConnectedState(
    serverIp: serverIp ?? super.serverIp,
    isMicOpen: isMicOpen ?? super.isMicOpen,
    exception: exception,
  );
}

final class OfflineChatCallState extends OfflineChatState {
  OfflineChatCallState({
    required super.serverIp,
    required super.isMicOpen,
    required this.callStatus,
    super.exception,
  });

  final CallStatus callStatus;

  @override
  OfflineChatCallState copyWith({
    String? serverIp,
    bool? isMicOpen,
    bool receivedCall = false,
    CallStatus? callStatus,
    Exception? exception,
  }) => OfflineChatCallState(
    serverIp: serverIp ?? super.serverIp,
    isMicOpen: isMicOpen ?? super.isMicOpen,
    exception: exception,

    callStatus: callStatus ?? this.callStatus,
  );
}
