import "package:cryptochat/features/online_chat/models/online_message.dart";
import 'package:cryptochat/features/shared/services/db/db_provider.dart';
import "package:cloud_firestore/cloud_firestore.dart";

import "dart:developer" as dev;

class FirebaseDbProvider implements DbProvider {
  FirebaseFirestore get _db => FirebaseFirestore.instance;
  static const String collectionPath = "chats";

  @override
  Future<void> sendMessage({required OnlineMessage message}) async {
    final Map<String, dynamic> data = message.toJson();
    data.addEntries([MapEntry("timestamp", FieldValue.serverTimestamp())]);
    final DocumentReference<Map<String, dynamic>> docRef = await _db
        .collection(collectionPath)
        .add(data);
    dev.log("Doc ${docRef.id} created: $data");
  }

  @override
  Future<List<OnlineMessage>> getAllMesages() async {
    final QuerySnapshot<Map<String, dynamic>> collection = await _db
        .collection(collectionPath)
        .get();
    return collection.docs.map(OnlineMessage.fromDoc).toList();
  }

  @override
  Stream<Iterable<OnlineMessage>> getMessageStream() {
    dev.log("Starting stream");
    final stream = _db
        .collection(collectionPath)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> collection) {
          return collection.docs.map(OnlineMessage.fromDoc);
        });
    return stream;
  }
}
