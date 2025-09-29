import 'dart:convert';
import 'dart:developer';
import 'dart:io';

class LocalChatService {
  Socket? clientSocket;
  ServerSocket? serverSocket;

  Future<void> startClient(String serverIp) async {
    clientSocket = await Socket.connect(serverIp, 4040);
    log("Connected to: ${clientSocket!.remoteAddress.address}");

    clientSocket!.add(utf8.encode("Hello from client!"));
    clientSocket!.listen((data) {
      log("Reply: ${utf8.decode(data)}");
    });
  }

  Future<void> startServer() async {
    serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, 4040);
    log(
      "Server running on: ${serverSocket!.address.address}:${serverSocket!.port}",
    );

    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
          log("Server reachable at: ${addr.address}:4040");
        }
      }
    }

    await for (final socket in serverSocket!) {
      socket.listen((data) {
        final message = utf8.decode(data);
        log("Received: $message");
        socket.add(utf8.encode("Echo: $message"));
        _sendMessage(socket, message);
      });
    }
  }

  void _sendMessage(Socket socket, String message) {
    socket.add(utf8.encode(message));
    log("Server sent: $message");
  }

  void clientSendMessage(String message) {
    _sendMessage(clientSocket!, message);
  }

  Future<void> stop() async {
    await clientSocket?.close();
    await serverSocket?.close();
  }
}
