import 'dart:typed_data';

import 'package:cryptochat/features/offline_chat/enums/message_type.dart';

class OfflineMessage {
  final MessageType type;
  final Uint8List rawData;
  final Uint8List noHeader;
  final String data;

  OfflineMessage({
    required this.type,
    required this.rawData,
    required this.noHeader,
    required this.data,
  });

  @override
  String toString() => "OfflineMessage($data)";
}
