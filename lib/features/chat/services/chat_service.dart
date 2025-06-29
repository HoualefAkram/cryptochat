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
      message: Message(
        owner: owner,
        message: message,
        dateTime: DateTime.now(),
      ),
    );
  }

  static Future<List<Message>> getAllMesages() => _db.getAllMesages();

  static Stream<Iterable<Message>> getMessageStream() => _db.getMessageStream();
}
