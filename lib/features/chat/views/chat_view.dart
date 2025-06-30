import 'package:cryptochat/features/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:cryptochat/features/chat/cubits/chat_cubit/chat_cubit.dart';
import 'package:cryptochat/features/chat/models/message.dart';
import 'package:cryptochat/features/shared/utils/themes/themes.dart';

import 'package:cryptochat/features/shared/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late final TextEditingController messageController;
  late final ScrollController scrollController;

  @override
  void initState() {
    messageController = TextEditingController();
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  bool _isAtBottom() =>
      !scrollController.hasClients ||
      scrollController.offset >= scrollController.position.maxScrollExtent - 70;

  bool _isUp() {
    if (!scrollController.hasClients) return true;

    final distanceFromBottom =
        scrollController.position.maxScrollExtent - scrollController.offset;

    return distanceFromBottom >= 800;
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void scrollIfAtBottom() {
    if (_isAtBottom()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollToBottom();
      });
    }
  }

  void _onScroll() {
    if (_isUp()) {
      context.read<ChatCubit>().setFABVisibility(true);
    } else {
      context.read<ChatCubit>().setFABVisibility(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is AuthLoggedInState) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: CAppBar(
              color: Colors.black,
              leading: Leading.back,
              onPop: () {
                context.read<AuthBloc>().add(AuthLogoutEvent());
              },
              leadingColor: Theme.of(context).primaryColor,
              centerTitle: false,
              title: Row(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        minRadius: 22,
                        backgroundImage: NetworkImage(
                          "https://upload.wikimedia.org/wikipedia/fr/3/3f/USTO-MB_%28logo%29.jpg",
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
                  Text("M1RT 2024/2025"),
                ],
              ),
              actions: [
                Container(
                  margin: EdgeInsets.all(12),
                  child: Icon(
                    Icons.call,
                    color: Theme.of(context).primaryColor,
                    size: 28,
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
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Center(
                  child: Column(
                    children: [
                      Expanded(
                        child: StreamBuilder(
                          stream: context.read<ChatCubit>().getMessageStream(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData || snapshot.data == null) {
                              return const Text("No data");
                            }
                            final List<Message> messages = snapshot.data!
                                .toList();
                            scrollIfAtBottom();
                            return ListView.builder(
                              controller: scrollController,
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                final Message msg = messages[index];
                                final bool isOwner =
                                    msg.owner == authState.user;
                                return Container(
                                  margin: EdgeInsets.all(2),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: isOwner
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                    children: [
                                      if (!isOwner)
                                        CircleAvatar(
                                          maxRadius: 14,
                                          backgroundColor: Colors.grey,
                                          backgroundImage: NetworkImage(
                                            "https://www.washingtonpost.com/news/the-intersect/wp-content/uploads/sites/32/2015/01/facebook-person.jpg",
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
                                              padding: const EdgeInsets.all(2),
                                              child: Text(
                                                msg.owner.name,
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
                                              msg.message,
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodyLarge?.copyWith(),
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
                      BlocBuilder<ChatCubit, ChatState>(
                        builder: (context, chatState) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                // Group of icons (always present in tree)
                                Row(
                                  children: [
                                    _buildIcon(
                                      !chatState.hasText,
                                      Icons.add_circle,
                                      context,
                                    ),
                                    _buildIcon(
                                      !chatState.hasText,
                                      Icons.camera_alt_rounded,
                                      context,
                                    ),
                                    _buildIcon(
                                      !chatState.hasText,
                                      Icons.image,
                                      context,
                                    ),
                                    _buildIcon(
                                      !chatState.hasText,
                                      Icons.mic,
                                      context,
                                    ),
                                  ],
                                ),

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
                                    onChanged: context
                                        .read<ChatCubit>()
                                        .setTextState,
                                  ),
                                ),
                                chatState.hasText
                                    ? IconButton(
                                        onPressed: () async {
                                          if (messageController.text
                                              .trim()
                                              .isEmpty) {
                                            return;
                                          }
                                          await context
                                              .read<ChatCubit>()
                                              .sendMessage(
                                                owner: authState.user,
                                                message: messageController.text,
                                              );
                                          messageController.clear();
                                          scrollToBottom();
                                        },
                                        icon: Icon(
                                          Icons.send,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      )
                                    : IconButton(
                                        onPressed: () {
                                          context.read<ChatCubit>().sendMessage(
                                            owner: authState.user,
                                            message: "👍",
                                          );
                                          scrollToBottom();
                                        },
                                        icon: Icon(
                                          Icons.thumb_up_alt_rounded,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                BlocBuilder<ChatCubit, ChatState>(
                  builder: (context, chatState) {
                    if (chatState.isFABvisible) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 100),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {
                            scrollToBottom();
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: CustomColors.bubleGreyDark,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.arrow_downward_rounded, size: 22),
                          ),
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),
              ],
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildIcon(bool visible, IconData icon, BuildContext context) {
    return visible
        ? Container(
            margin: EdgeInsets.all(6),
            child: Icon(icon, color: Theme.of(context).primaryColor),
          )
        : const SizedBox.shrink(); // takes no space
  }
}
