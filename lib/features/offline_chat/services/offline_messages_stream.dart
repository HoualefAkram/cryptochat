import 'dart:async';

import 'package:cryptochat/features/offline_chat/models/offline_message.dart';

class OfflineMessagesStream {
  static final OfflineMessagesStream _instance =
      OfflineMessagesStream._internal();
  factory OfflineMessagesStream() => _instance;
  OfflineMessagesStream._internal();

  final StreamController<OfflineMessage> _messageController =
      StreamController<OfflineMessage>.broadcast();

  Stream<OfflineMessage> get stream => _messageController.stream;

  void add(OfflineMessage message) {
    _messageController.add(message);
  }
}
