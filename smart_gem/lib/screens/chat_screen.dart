import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_gem/providers/chat_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //message controller
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 375;
    double height = MediaQuery.of(context).size.height / 812;

    return Consumer<ChatProvider>(builder: (context, chatProvider, child) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Chat Screen"),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 8 * width,
            ),
            child: Column(
              children: [
                Expanded(
                  child: chatProvider.inChatMessages.isEmpty
                      ? const Center(
                          child: Text("No messages yet"),
                        )
                      : ListView.builder(
                          itemCount: chatProvider.inChatMessages.length,
                          itemBuilder: (context, index) {
                            final message = chatProvider.inChatMessages[index];
                            return ListTile(
                              title: Text(message.message.toString()),
                            );
                          },
                        ),
                ),
                //input field
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8 * width,
                    vertical: 8 * height,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          decoration: const InputDecoration(
                            hintText: "Type a message",
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          //chatProvider.sendMessage();
                        },
                        icon: const Icon(Icons.send),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
