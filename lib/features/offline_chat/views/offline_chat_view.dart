import 'package:cryptochat/features/auth/constants/images.dart';
import 'package:cryptochat/features/offline_chat/cubits/offline_chat_cubit/offline_chat_cubit.dart';
import 'package:cryptochat/features/offline_chat/cubits/offline_chat_cubit/offline_chat_exceptions.dart';
import 'package:cryptochat/features/offline_chat/models/offline_message.dart';
import 'package:cryptochat/features/offline_chat/views/no_server_view.dart';
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
                          backgroundImage: NetworkImage(CImage.nUstoPic),
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
                        context.read<OfflineChatCubit>().toggleAudio();
                      },
                      child: Icon(
                        Icons.call,
                        color: offlineState.isMicOpen
                            ? Colors.green
                            : Colors.red,
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
                                  return Text(msg.data);

                                  // final bool isOwner =
                                  //     msg.owner == authState.user;
                                  // return Container(
                                  //   margin: EdgeInsets.all(2),
                                  //   child: Row(
                                  //     mainAxisSize: MainAxisSize.max,
                                  //     crossAxisAlignment:
                                  //         CrossAxisAlignment.end,
                                  //     mainAxisAlignment: isOwner
                                  //         ? MainAxisAlignment.end
                                  //         : MainAxisAlignment.start,
                                  //     children: [
                                  //       if (!isOwner)
                                  //         CircleAvatar(
                                  //           maxRadius: 14,
                                  //           backgroundColor: Colors.grey,
                                  //           backgroundImage: NetworkImage(
                                  //             CImage.nProfilePic,
                                  //           ),
                                  //         ),
                                  //       SizedBox(width: 10),
                                  //       Column(
                                  //         crossAxisAlignment: isOwner
                                  //             ? CrossAxisAlignment.end
                                  //             : CrossAxisAlignment.start,
                                  //         children: [
                                  //           if (!isOwner)
                                  //             Padding(
                                  //               padding: const EdgeInsets.all(
                                  //                 2,
                                  //               ),
                                  //               child: Text(
                                  //                 msg.owner.name,
                                  //                 style: TextStyle(
                                  //                   color: Colors.grey,
                                  //                   fontSize: 12,
                                  //                 ),
                                  //               ),
                                  //             ),

                                  //           Container(
                                  //             padding: EdgeInsets.all(8),
                                  //             constraints: BoxConstraints(
                                  //               maxWidth:
                                  //                   MediaQuery.sizeOf(
                                  //                     context,
                                  //                   ).width *
                                  //                   0.5,
                                  //             ),
                                  //             decoration: BoxDecoration(
                                  //               color: isOwner
                                  //                   ? Theme.of(
                                  //                       context,
                                  //                     ).primaryColor
                                  //                   : CustomColors.bubleGrey,
                                  //               borderRadius:
                                  //                   BorderRadius.circular(24),
                                  //             ),
                                  //             child: Text(
                                  //               msg.text,
                                  //               style: Theme.of(context)
                                  //                   .textTheme
                                  //                   .bodyLarge
                                  //                   ?.copyWith(),
                                  //             ),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ],
                                  //   ),
                                  // );
                                },
                              );
                            },
                          ),
                        ),

                        TextField(controller: messageController),
                        ElevatedButton(
                          onPressed: () {
                            context.read<OfflineChatCubit>().sendMessage(
                              messageController.text,
                            );
                          },
                          child: const Text("Send"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return NoServerView();
        }
      },
    );
  }
}
