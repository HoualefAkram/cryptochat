import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String owner;
  final String message;
  final Timestamp? timeStamp;

  Message({
    required this.owner,
    required this.message,
    required this.timeStamp,
  });

  factory Message.fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final Map<String, dynamic> data = doc.data();
    return Message(
      owner: data["owner"],
      message: data["message"],
      timeStamp: data["timeStamp"],
    );
  }

  @override
  String toString() =>
      "Message(owner: $owner, value: $message, timeStamp: $timeStamp)";
}
