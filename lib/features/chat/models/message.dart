import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptochat/features/auth/models/auth_user.dart';

class Message {
  final AuthUser owner;
  final String message;

  Message({required this.owner, required this.message});

  factory Message.fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final Map<String, dynamic> data = doc.data();
    return Message(owner: AuthUser.fromJson(data), message: data["message"]);
  }

  Map<String, dynamic> toJson() => {...owner.toJson(), "message": message};

  factory Message.fromJson(Map<String, dynamic> json) =>
      Message(owner: AuthUser.fromJson(json), message: json["message"]);

  @override
  String toString() => "Message(owner: $owner, value: $message)";
}
