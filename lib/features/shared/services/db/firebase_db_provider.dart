import "package:cryptochat/features/chat/models/message.dart";
import 'package:cryptochat/features/shared/services/db/db_provider.dart';
import "package:cloud_firestore/cloud_firestore.dart";

import "dart:developer" as dev;

class FirebaseDbProvider implements DbProvider {
  FirebaseFirestore get _db => FirebaseFirestore.instance;
  static const String collectionPath = "chats";

  @override
  Future<void> sendMessage({required Message message}) async {
    final Map<String, dynamic> data = message.toJson();
    final DocumentReference<Map<String, dynamic>> docRef = await _db
        .collection(collectionPath)
        .add(data);
    dev.log("Doc ${docRef.id} created: $data");
  }

  @override
  Future<List<Message>> getAllMesages() async {
    final QuerySnapshot<Map<String, dynamic>> collection = await _db
        .collection(collectionPath)
        .get();
    return collection.docs.map(Message.fromDoc).toList();
  }

  @override
  Stream<Iterable<Message>> getMessageStream() {
    dev.log("Starting stream");
    final stream = _db
        .collection(collectionPath)
        .orderBy('dateTime', descending: false)
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> collection) {
          return collection.docs.map(Message.fromDoc);
        });
    return stream;
  }
}
