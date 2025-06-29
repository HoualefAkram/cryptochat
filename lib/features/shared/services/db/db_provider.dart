import 'package:cryptochat/features/chat/models/message.dart';

abstract class DbProvider {
  Future<void> sendMessage({required Message message});
  Future<List<Message>> getAllMesages();
  Stream<Iterable<Message>> getMessageStream();
}
