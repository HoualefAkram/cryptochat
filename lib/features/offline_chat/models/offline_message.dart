import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptochat/features/offline_chat/enums/message_type.dart';

class OfflineMessage {
  final MessageType type;
  final Uint8List rawData;
  final Uint8List noHeader;
  final String data;
  final String owner;

  OfflineMessage({
    required this.type,
    required this.rawData,
    required this.noHeader,
    required this.data,
    required this.owner,
  });

  factory OfflineMessage.fromString(String str, String owner) => OfflineMessage(
    type: MessageType.text,
    rawData: utf8.encode(str),
    noHeader: utf8.encode(str), // TODO: false
    data: str,
    owner: owner,
  );

  @override
  String toString() => "OfflineMessage($data)";
}
