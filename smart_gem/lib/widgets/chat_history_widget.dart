import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_gem/hive/chat_history.dart';
import 'package:smart_gem/providers/chat_provider.dart';

class ChatHistoryWidget extends StatelessWidget {
  const ChatHistoryWidget({super.key, required this.chat});

  final ChatHistory chat;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
        leading: const CircleAvatar(
          radius: 30,
          child: Icon(Icons.chat),
        ),
        title: Text(
          chat.prompt,
          maxLines: 1,
        ),
        subtitle: Text(
          chat.response.toString(),
          maxLines: 2,
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () async {
          // navigate to chat screen
          final chatProvider = context.read<ChatProvider>();
         
          chatProvider.setCurrentIndex(index: 1);
          chatProvider.pageController.jumpToPage(1);
        },
        onLongPress: () {
          
        },
      ),
    );
  }
}
