import 'dart:developer' show log;
import 'dart:io';

import 'package:cryptochat/features/auth/models/auth_user.dart';
import 'package:cryptochat/features/chat/models/message.dart';
import 'package:cryptochat/features/shared/services/db/db_service.dart';

class ChatService {
  static DbService get _db => DbService.firebase();

  static Future<void> sendMessage({
    required String message,
    required AuthUser owner,
  }) async {
    _db.sendMessage(
      message: Message(owner: owner, text: message),
    );
  }

  static Future<List<Message>> getAllMesages() => _db.getAllMesages();

  static Stream<Iterable<Message>> getMessageStream() => _db.getMessageStream();

  Future<void> udpBroadcast() async {
    final rawSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    rawSocket.broadcastEnabled = true;

    final message = "Hello everyone on the network!";
    final data = message.codeUnits;

    rawSocket.send(data, InternetAddress("255.255.255.255"), 4040);

    log("Broadcast sent: $message");
  }

  Future<void> udpListener() async {
    final rawSocket = await RawDatagramSocket.bind(
      InternetAddress.anyIPv4,
      4040,
    );
    log("Listening for UDP broadcasts on port 4040...");

    rawSocket.listen((event) {
      if (event == RawSocketEvent.read) {
        final datagram = rawSocket.receive();
        if (datagram != null) {
          final message = String.fromCharCodes(datagram.data);
          log("Received from ${datagram.address.address}: $message");
        }
      }
    });
  }
}
