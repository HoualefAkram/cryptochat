import 'package:cryptochat/features/chat/models/message.dart';

abstract class DbProvider {
  Future<void> initialize();
  Future<void> sendMessage({required String message, required String owner});
  Future<List<Message>> getAllMesages();
  Stream<Iterable<Message>> getMessageStream();
}
