import 'package:cryptochat/features/offline_chat/cubits/offline_chat_cubit/offline_chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoServerView extends StatefulWidget {
  const NoServerView({super.key});

  @override
  State<NoServerView> createState() => _NoServerViewState();
}

class _NoServerViewState extends State<NoServerView> {
  late final TextEditingController ipAdressController;

  @override
  void initState() {
    ipAdressController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<OfflineChatCubit>().startServer();
    });

    super.initState();
  }

  @override
  void dispose() {
    ipAdressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OfflineChatCubit, OfflineChatState>(
      builder: (context, offlineState) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Your IP: ${offlineState.serverIp}",
                  style: TextStyle(fontSize: 23),
                ),
                const SizedBox(height: 20),
                Text("No conncted user.", style: TextStyle(fontSize: 18)),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: ipAdressController,
                    decoration: InputDecoration(hintText: "User IP"),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<OfflineChatCubit>().connect(
                      ipAdressController.text,
                    );
                  },
                  child: const Text("Connect"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
