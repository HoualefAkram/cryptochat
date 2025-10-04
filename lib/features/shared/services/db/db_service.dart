import 'package:cryptochat/features/online_chat/models/online_message.dart';
import 'package:cryptochat/features/shared/services/db/db_provider.dart';
import 'package:cryptochat/features/shared/services/db/firebase_db_provider.dart';

class DbService implements DbProvider {
  final DbProvider provider;
  DbService(this.provider);

  factory DbService.firebase() => DbService(FirebaseDbProvider());

  @override
  Future<void> sendMessage({required OnlineMessage message}) =>
      provider.sendMessage(message: message);

  @override
  Stream<Iterable<OnlineMessage>> getMessageStream() =>
      provider.getMessageStream();

  @override
  Future<List<OnlineMessage>> getAllMesages() => provider.getAllMesages();
}
