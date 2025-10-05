import 'package:cryptochat/features/offline_chat/cubits/offline_chat_cubit/offline_chat_cubit.dart';
import 'package:cryptochat/features/offline_chat/views/no_server_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OfflineChatView extends StatefulWidget {
  const OfflineChatView({super.key});

  @override
  State<OfflineChatView> createState() => _OfflineChatViewState();
}

class _OfflineChatViewState extends State<OfflineChatView> {
  late final TextEditingController messageController;

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
    return Scaffold(
      body: BlocBuilder<OfflineChatCubit, OfflineChatState>(
        builder: (context, offlineState) {
          if (offlineState is OfflineChatConnectedState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: messageController,
                  decoration: InputDecoration(hintText: "message"),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<OfflineChatCubit>().sendMessage(
                      messageController.text,
                    );
                  },
                  child: const Text("send"),
                ),
              ],
            );
          } else {
            return NoServerView();
          }
        },
      ),
    );
  }
}
