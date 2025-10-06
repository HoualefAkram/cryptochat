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
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Your IP: ${offlineState.serverIp}",
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    "No conncted user.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    margin: const EdgeInsets.only(bottom: 8.0),
                    child: TextField(
                      controller: ipAdressController,
                      decoration: InputDecoration(
                        hintText: "User IP",
                        hintStyle: TextStyle(color: Colors.white30),
                        filled: true,
                        fillColor: Color.fromARGB(255, 51, 62, 77),
                        enabledBorder: _buildBorder(),
                        focusedBorder: _buildBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      onPressed: () {
                        context.read<OfflineChatCubit>().connect(
                          ipAdressController.text,
                        );
                      },
                      child: const Text(
                        "Connect",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  OutlineInputBorder _buildBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Color.fromARGB(255, 64, 78, 97), width: 1),
    );
  }
}
