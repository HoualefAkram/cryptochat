import 'package:cryptochat/features/chat/models/message.dart';
import 'package:cryptochat/features/shared/services/db/db_service.dart';

class ChatService {
  static DbService get _db => DbService.firebase();

  static Future<void> initialize() => _db.initialize();

  static Future<void> sendMessage({required String message}) async {
    // TODO: get owner from login
    _db.sendMessage(message: message, owner: "akram");
  }

  static Future<List<Message>> getAllMesages() => _db.getAllMesages();

  static Stream<Iterable<Message>> getMessageStream() => _db.getMessageStream();
}
