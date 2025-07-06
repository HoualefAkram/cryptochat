import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptochat/features/auth/models/auth_user.dart';
import 'package:cryptochat/features/cryptography/services/ciphers/custom_cipher.dart';

class Message {
  final AuthUser owner;
  final String text;

  Message({required this.owner, required this.text});

  factory Message.fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final Map<String, dynamic> data = doc.data();
    return Message(owner: AuthUser.fromJson(data), text: data["message"]);
  }

  Map<String, dynamic> toJson() => {...owner.toJson(), "message": text};

  factory Message.fromJson(Map<String, dynamic> json) =>
      Message(owner: AuthUser.fromJson(json), text: json["message"]);

  Message encode(int? seed) =>
      Message(owner: owner, text: Cipher.encode(text.trim(), seed));

  Message decode(int? seed) =>
      Message(owner: owner, text: Cipher.decode(text, seed));

  @override
  String toString() => "Message(owner: $owner, value: $text)";
}
