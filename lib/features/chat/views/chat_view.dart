import 'package:cryptochat/features/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:cryptochat/features/chat/models/message.dart';
import 'package:cryptochat/features/chat/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late TextEditingController messageController;

  @override
  void initState() {
    messageController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is AuthLoggedInState) {
          return Scaffold(
            appBar: AppBar(title: Text("Welcome, ${authState.user.name}")),
            body: Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      ChatService.sendMessage(
                        owner: authState.user,
                        message: "Akran message",
                      );
                    },
                    child: const Text("Send message"),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthLogoutEvent());
                    },
                    child: const Text("Logout"),
                  ),

                  TextField(
                    controller: messageController,
                    decoration: InputDecoration(hint: Text("Mesage")),
                  ),

                  Expanded(
                    child: StreamBuilder(
                      stream: ChatService.getMessageStream(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData && snapshot.data == null) {
                          return const Text("No data");
                        }
                        final List<Message> data = snapshot.data!.toList();
                        return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final Message msg = data[index];
                            return Text("${msg.owner.name} : ${msg.message}");
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
