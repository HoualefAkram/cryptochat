import 'package:cryptochat/features/offline_chat/cubits/offline_chat_cubit/offline_chat_cubit.dart';
import 'package:cryptochat/features/offline_chat/cubits/offline_chat_cubit/offline_chat_exceptions.dart';
import 'package:cryptochat/features/offline_chat/models/offline_message.dart';
import 'package:cryptochat/features/shared/utils/custom_icon/custom_icon.dart';
import 'package:cryptochat/features/shared/utils/snackbar/generic_snackbar.dart';
import 'package:cryptochat/features/shared/utils/themes/themes.dart';
import 'package:cryptochat/features/shared/widgets/app_bar.dart';
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
    return BlocConsumer<OfflineChatCubit, OfflineChatState>(
      listener: (context, offlineState) {
        if (offlineState.exception is FailedToConnectToServerException) {
          ESnackBar.error(context, "Failed to connect to server.");
        }
      },
      builder: (context, offlineState) {
        if (offlineState is OfflineChatConnectedState) {
          return SafeArea(
            child: Scaffold(
              appBar: CAppBar(
                leading: Leading.back,
                color: Colors.black,
                leadingColor: Theme.of(context).primaryColor,
                title: Row(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          minRadius: 22,
                          backgroundImage: AssetImage(
                            CustomIcon.resolve(CIcon.user),
                          ),
                        ),
                        Container(
                          height: 16,
                          width: 16,
                          decoration: BoxDecoration(
                            color: CustomColors.activeGreen,
                            shape: BoxShape.circle,
                            border: Border.all(width: 3),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 12),
                    Text("LOCAL CHAT"),
                  ],
                ),
                actions: [
                  Container(
                    margin: EdgeInsets.all(12),
                    child: InkWell(
                      onTap: () {
                        context.read<OfflineChatCubit>().startVoiceConnection();
                      },
                      child: Icon(
                        Icons.call,
                        color: Theme.of(context).primaryColor,
                        size: 28,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(12),
                    child: Icon(
                      Icons.videocam,
                      color: Theme.of(context).primaryColor,
                      size: 28,
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.black,

              body: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Expanded(
                          child: StreamBuilder(
                            stream: context
                                .read<OfflineChatCubit>()
                                .getMessagesStream(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData || snapshot.data == null) {
                                return const Text("No data");
                              }
                              final List<OfflineMessage> messages = snapshot
                                  .data!
                                  .toList();
                              return ListView.builder(
                                itemCount: messages.length,
                                itemBuilder: (context, index) {
                                  final OfflineMessage msg = messages[index];

                                  final bool isOwner = context
                                      .read<OfflineChatCubit>()
                                      .isOwner(msg);
                                  return Container(
                                    margin: EdgeInsets.all(2),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment: isOwner
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                      children: [
                                        if (!isOwner)
                                          CircleAvatar(
                                            maxRadius: 14,
                                            backgroundColor: Colors.grey,
                                            backgroundImage: AssetImage(
                                              CustomIcon.resolve(CIcon.user),
                                            ),
                                          ),
                                        SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment: isOwner
                                              ? CrossAxisAlignment.end
                                              : CrossAxisAlignment.start,
                                          children: [
                                            if (!isOwner)
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  2,
                                                ),
                                                child: Text(
                                                  msg.owner,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),

                                            Container(
                                              padding: EdgeInsets.all(8),
                                              constraints: BoxConstraints(
                                                maxWidth:
                                                    MediaQuery.sizeOf(
                                                      context,
                                                    ).width *
                                                    0.5,
                                              ),
                                              decoration: BoxDecoration(
                                                color: isOwner
                                                    ? Theme.of(
                                                        context,
                                                      ).primaryColor
                                                    : CustomColors.bubleGrey,
                                                borderRadius:
                                                    BorderRadius.circular(24),
                                              ),
                                              child: Text(
                                                msg.data,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.copyWith(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: messageController,
                                  minLines: 1,
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                    filled: true,
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(8),
                                    fillColor: CustomColors.bubleGrey,
                                    hintText: "Message",
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  if (messageController.text.trim().isEmpty) {
                                    return;
                                  }
                                  await context
                                      .read<OfflineChatCubit>()
                                      .sendMessage(messageController.text);
                                  messageController.clear();
                                },
                                icon: Icon(
                                  Icons.send,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: Text("Unknown state: ${offlineState.runtimeType}"),
            ),
          );
        }
      },
    );
  }
}
