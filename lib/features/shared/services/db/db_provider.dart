import 'package:cryptochat/features/online_chat/models/online_message.dart';

abstract class DbProvider {
  Future<void> sendMessage({required OnlineMessage message});
  Future<List<OnlineMessage>> getAllMesages();
  Stream<Iterable<OnlineMessage>> getMessageStream();
}
