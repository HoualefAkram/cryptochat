import 'package:cryptochat/features/chat/models/message.dart';
import 'package:cryptochat/features/shared/services/db/db_provider.dart';
import 'package:cryptochat/features/shared/services/db/firebase_db_provider.dart';

class DbService implements DbProvider {
  final DbProvider provider;
  DbService(this.provider);

  factory DbService.firebase() => DbService(FirebaseDbProvider());

  @override
  Future<void> initialize() => provider.initialize();

  @override
  Future<void> sendMessage({required String message, required String owner}) =>
      provider.sendMessage(message: message, owner: owner);

  @override
  Stream<Iterable<Message>> getMessageStream() => provider.getMessageStream();

  @override
  Future<List<Message>> getAllMesages() => provider.getAllMesages();
}
