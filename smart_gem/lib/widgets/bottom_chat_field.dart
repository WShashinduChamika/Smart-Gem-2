import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smart_gem/providers/chat_provider.dart';

class BottomChatField extends StatefulWidget {
  const BottomChatField({super.key, required this.chatProvider});
  final ChatProvider chatProvider;
  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  final TextEditingController messageController = TextEditingController();

  final FocusNode textFieldFocusNode = FocusNode();

  @override
  void dispose() {
    // TODO: implement dispose
    messageController.dispose();
    textFieldFocusNode.dispose();
    super.dispose();
  }
  
  Future<void> sendMessage({
    required String message,
    required ChatProvider chatProvider,
    required bool isTextOnly
  }) async {
    //send message
    try {
      await chatProvider.sendMessage(
        message: message,
        isTextOnly: isTextOnly,
      );
    } catch (e) {
      print('eror : $e ');

    } finally {
      messageController.clear();
      textFieldFocusNode.unfocus();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Theme.of(context).textTheme.labelLarge!.color!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              //send image
            },
            icon: const Icon(Icons.image),
          ),
          Expanded(
            child: TextField(
              focusNode: textFieldFocusNode,
              controller: messageController,
              textInputAction: TextInputAction.send,
              onSubmitted: (String value) {
                //chatProvider.sendMessage();
                if(value.isNotEmpty){
                sendMessage(
                  message: messageController.text,
                  chatProvider: widget.chatProvider,
                  isTextOnly: true,
                );
              }
              },
              decoration: InputDecoration.collapsed(
                hintText: "Enter your prompt here...",
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              //send message
              if(messageController.text.isNotEmpty){
                sendMessage(
                  message: messageController.text,
                  chatProvider: widget.chatProvider,
                  isTextOnly: true,
                );
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
