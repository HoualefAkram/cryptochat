import 'dart:async';

import 'package:cryptochat/features/offline_chat/models/offline_message.dart';

class OfflineMessagesStream {
  final StreamController<OfflineMessage> _messageController =
      StreamController<OfflineMessage>();

  Stream<OfflineMessage> get stream => _messageController.stream;

  void add(OfflineMessage message) {
    _messageController.add(message);
  }
}
