import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptochat/features/auth/models/auth_user.dart';

class Message {
  final AuthUser owner;
  final String message;
  final DateTime dateTime;

  Message({required this.owner, required this.message, required this.dateTime});

  factory Message.fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final Map<String, dynamic> data = doc.data();
    return Message(
      owner: AuthUser.fromJson(data),
      message: data["message"],
      dateTime: DateTime.parse(data["dateTime"]),
    );
  }

  Map<String, dynamic> toJson() => {
    ...owner.toJson(),
    "message": message,
    "dateTime": dateTime.toIso8601String(),
  };

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    owner: AuthUser.fromJson(json),
    message: json["message"],
    dateTime: DateTime.parse(json["dateTime"]),
  );

  @override
  String toString() =>
      "Message(owner: $owner, value: $message, dateTime: $dateTime)";
}
