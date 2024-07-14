import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_gem/models/model.dart';
import 'package:smart_gem/providers/chat_provider.dart';
import 'package:smart_gem/widgets/assistance_message.dart';
import 'package:smart_gem/widgets/bottom_chat_field.dart';
import 'package:smart_gem/widgets/my_message_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  void scrollBottom() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (_scrollController.hasClients &&
          _scrollController.position.maxScrollExtent > 0) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width / 375;
    double height = MediaQuery.of(context).size.height / 812;

    return Consumer<ChatProvider>(builder: (context, chatProvider, child) {

      if(chatProvider.inChatMessages.isNotEmpty){
        scrollBottom();
      }

      //auto scroll to bottom on new message
      chatProvider.addListener(() {
        if (chatProvider.inChatMessages.isNotEmpty) {
          scrollBottom();
        }
      });

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
                          controller: _scrollController,
                          itemCount: chatProvider.inChatMessages.length,
                          itemBuilder: (context, index) {
                            final message = chatProvider.inChatMessages[index];
                            return message.role == Role.user
                                ? MyMessages(message: message)
                                : AssistanceMessage(
                                    message: message.message.toString());
                          },
                        ),
                ),
                //input field
                BottomChatField(chatProvider: chatProvider),
              ],
            ),
          ),
        ),
      );
    });
  }
}
