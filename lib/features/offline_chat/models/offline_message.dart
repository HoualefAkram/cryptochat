import 'package:cryptochat/features/offline_chat/enums/message_type.dart';

class OfflineMessage {
  final MessageType type;
  final dynamic data;
  final String owner;

  OfflineMessage({required this.type, required this.data, required this.owner});

  @override
  String toString() => "OfflineMessage($data)";
}
