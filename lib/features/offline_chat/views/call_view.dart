import 'package:cryptochat/features/offline_chat/cubits/offline_chat_cubit/offline_chat_cubit.dart';
import 'package:cryptochat/features/offline_chat/enums/call_status.dart';
import 'package:cryptochat/features/shared/utils/custom_icon/custom_icon.dart';
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
            body: _buildCallWidget(context, state: offlineState),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                context.read<OfflineChatCubit>().toggleMicrophone();
              },
              child: Icon(offlineState.isMicOpen ? Icons.mic : Icons.mic_off),
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

  Widget _buildCallWidget(
    BuildContext context, {
    required OfflineChatCallState state,
  }) {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue, Colors.purple],
          stops: [0.6, 1.0],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey,
            minRadius: 30,
            backgroundImage: AssetImage(CustomIcon.resolve(CIcon.user)),
          ),
          const SizedBox(height: 10),
          Text("Status: ${state.callStatus.name.toUpperCase()}"),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (state.callStatus == CallStatus.incoming)
                Column(
                  children: [
                    ElevatedButton.icon(
                      style: ButtonStyle(
                        shape: WidgetStatePropertyAll(CircleBorder()),
                        backgroundColor: WidgetStatePropertyAll(Colors.green),
                      ),
                      onPressed: () {
                        context.read<OfflineChatCubit>().acceptCall();
                      },
                      label: Icon(Icons.phone_enabled),
                    ),
                    const SizedBox(height: 6),
                    Text("Accept"),
                  ],
                ),
              const SizedBox(width: 50),
              Column(
                children: [
                  ElevatedButton.icon(
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(CircleBorder()),
                      backgroundColor: WidgetStatePropertyAll(Colors.red),
                    ),
                    onPressed: () {
                      if (state.callStatus == CallStatus.incoming) {
                        context.read<OfflineChatCubit>().refuseCall();
                      }
                      if (state.callStatus == CallStatus.live) {
                        context.read<OfflineChatCubit>().endCall();
                      }
                    },
                    label: Icon(Icons.phone_disabled_rounded),
                  ),
                  const SizedBox(height: 6),
                  Text("Decline"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
