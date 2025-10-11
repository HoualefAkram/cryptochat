import 'package:cryptochat/features/offline_chat/cubits/offline_chat_cubit/offline_chat_cubit.dart';
import 'package:cryptochat/features/offline_chat/enums/call_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CallView extends StatefulWidget {
  const CallView({super.key});

  @override
  State<CallView> createState() => _CallViewState();
}

class _CallViewState extends State<CallView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OfflineChatCubit, OfflineChatState>(
      builder: (context, offlineState) {
        if (offlineState is OfflineChatCallState) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("STATE: ${offlineState.callStatus.name}"),
                  const SizedBox(height: 20),
                  if (offlineState.callStatus == CallStatus.incoming)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            context.read<OfflineChatCubit>().refuseCall();
                          },
                          child: Text("REFUSE"),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<OfflineChatCubit>().acceptCall();
                          },
                          child: Text("ACCEPT"),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        }
        return Scaffold(
          body: Center(
            child: Text("Unknown state: ${offlineState.runtimeType}"),
          ),
        );
      },
    );
  }
}
