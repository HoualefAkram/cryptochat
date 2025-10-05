import 'package:cryptochat/features/offline_chat/cubits/offline_chat_cubit/offline_chat_cubit.dart';
import 'package:cryptochat/features/offline_chat/cubits/offline_chat_cubit/offline_chat_exceptions.dart';
import 'package:cryptochat/features/offline_chat/views/no_server_view.dart';
import 'package:cryptochat/features/shared/utils/snackbar/generic_snackbar.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<OfflineChatCubit>().initAudio();
      context.read<OfflineChatCubit>().listenToMessages();
    });
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
      body: BlocConsumer<OfflineChatCubit, OfflineChatState>(
        listener: (context, offlineState) {
          if (offlineState.exception is FailedToConnectToServerException) {
            ESnackBar.error(context, "Failed to connect to server.");
          }
        },
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
                ElevatedButton(
                  onPressed: () {
                    context.read<OfflineChatCubit>().toggleAudio();
                  },
                  child: Text("IS RECORDING: ${offlineState.isMicOpen}"),
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
