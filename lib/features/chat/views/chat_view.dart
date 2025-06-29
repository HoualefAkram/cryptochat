import 'package:cryptochat/features/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:cryptochat/features/chat/cubits/chat_cubit/chat_cubit.dart';
import 'package:cryptochat/features/chat/models/message.dart';
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
                      context.read<AuthBloc>().add(AuthLogoutEvent());
                    },
                    child: const Text("Logout"),
                  ),

                  TextField(
                    controller: messageController,
                    decoration: InputDecoration(hint: Text("Mesage")),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (messageController.text.trim().isEmpty) return;
                      await context.read<ChatCubit>().sendMessage(
                        owner: authState.user,
                        message: messageController.text,
                      );
                      messageController.clear();
                    },
                    child: const Text("Send message"),
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: context.read<ChatCubit>().getMessageStream(),
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
