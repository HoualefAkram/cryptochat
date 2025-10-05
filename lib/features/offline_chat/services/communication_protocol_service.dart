import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptochat/features/offline_chat/enums/message_type.dart';
import 'package:cryptochat/features/offline_chat/models/offline_message.dart';

class ComProtocol {
  static const String _connectMessage = "CONNECT_MESSAGE";
  static const String _audioDataMessage = "AUDIO_DATA_MESSAGE";
  static const String _textMessage = "TEXT_MESSAGE";

  static String get connectMessage => _connectMessage;
  static String get audioDataMessage => _audioDataMessage;
  static String get textMEssage => _textMessage;

  static bool _isAudioDataMessage(Uint8List bytes) {
    final String message = utf8.decode(bytes);
    return message.startsWith(_audioDataMessage);
  }

  static bool _isConnectMessage(Uint8List bytes) {
    final String message = utf8.decode(bytes);
    return message.startsWith(_connectMessage);
  }

  static bool _isTextMessage(Uint8List bytes) {
    final String message = utf8.decode(bytes);
    return message.startsWith(_textMessage);
  }

  static Uint8List _removeHeader(Uint8List bytes) {
    final String message = utf8.decode(bytes);
    final int separatorIndex = message.indexOf(':');
    if (separatorIndex == -1 || separatorIndex + 1 >= message.length) {
      return Uint8List.fromList([]);
    }
    return utf8.encode(message.substring(separatorIndex + 1));
  }

  static MessageType _messageType(Uint8List bytes) {
    if (_isAudioDataMessage(bytes)) {
      return MessageType.audio;
    } else if (_isConnectMessage(bytes)) {
      return MessageType.connect;
    } else if (_isTextMessage(bytes)) {
      return MessageType.text;
    } else {
      return MessageType.unknown;
    }
  }

  static OfflineMessage parseData(Uint8List bytes) {
    final MessageType type = _messageType(bytes);
    final Uint8List rawData = bytes;
    final Uint8List noHeader = _removeHeader(bytes);
    final String data = utf8.decode(noHeader);

    return OfflineMessage(
      type: type,
      rawData: rawData,
      noHeader: noHeader,
      data: data,
    );
  }

  static String signData({required MessageType type, required dynamic data}) {
    String prefix;

    switch (type) {
      case MessageType.text:
        prefix = _textMessage;
        break;
      case MessageType.audio:
        prefix = _audioDataMessage;
        break;
      case MessageType.connect:
        prefix = _connectMessage;
        break;
      default:
        throw ArgumentError('Unsupported MessageType: $type');
    }

    return "$prefix:$data";
  }
}
