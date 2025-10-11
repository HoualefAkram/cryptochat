import 'dart:convert';
import 'dart:typed_data';
import 'package:cryptochat/features/offline_chat/enums/message_type.dart';
import 'package:cryptochat/features/offline_chat/models/offline_message.dart';

class ComProtocol {
  static final ComProtocol _instance = ComProtocol._internal();
  factory ComProtocol() => _instance;
  ComProtocol._internal();

  static OfflineMessage decode(Uint8List bytes) {
    final String decodedUtf8 = utf8.decode(bytes);
    final Map<String, dynamic> json = jsonDecode(decodedUtf8);
    final Map<String, dynamic> headers = json["headers"];
    final Map<String, dynamic> body = json["body"];
    return OfflineMessage(
      owner: headers["owner"],
      type: MessageTypeParser.fromString(headers["type"] as String),
      data: body["data"],
    );
  }

  static Uint8List encode({
    required MessageType type,
    required String owner,
    required dynamic data,
  }) {
    final Map<String, dynamic> headers = {"type": type.name, "owner": owner};
    final Map<String, dynamic> body = {"data": data};
    final Map<String, dynamic> request = {"headers": headers, "body": body};
    final String encodedReq = jsonEncode(request);
    final Uint8List utf8Request = utf8.encode(encodedReq);

    return utf8Request;
  }
}
