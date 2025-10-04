import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptochat/features/auth/models/auth_user.dart';
import 'package:cryptochat/features/cryptography/services/ciphers/custom_cipher.dart';

class OnlineMessage {
  final AuthUser owner;
  final String text;

  OnlineMessage({required this.owner, required this.text});

  factory OnlineMessage.fromDoc(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final Map<String, dynamic> data = doc.data();
    return OnlineMessage(owner: AuthUser.fromJson(data), text: data["message"]);
  }

  Map<String, dynamic> toJson() => {...owner.toJson(), "message": text};

  factory OnlineMessage.fromJson(Map<String, dynamic> json) =>
      OnlineMessage(owner: AuthUser.fromJson(json), text: json["message"]);

  OnlineMessage encode(int? seed) =>
      OnlineMessage(owner: owner, text: Cipher.encode(text.trim(), seed));

  OnlineMessage decode(int? seed) =>
      OnlineMessage(owner: owner, text: Cipher.decode(text, seed));

  @override
  String toString() => "Message(owner: $owner, value: $text)";
}
