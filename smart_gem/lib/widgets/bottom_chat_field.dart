import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_gem/providers/chat_provider.dart';
import 'package:smart_gem/widgets/preview_images.dart';

class BottomChatField extends StatefulWidget {
  const BottomChatField({super.key, required this.chatProvider});
  final ChatProvider chatProvider;
  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  final TextEditingController messageController = TextEditingController();

  final FocusNode textFieldFocusNode = FocusNode();

  final ImagePicker imagePicker = ImagePicker();

  @override
  void dispose() {
    // TODO: implement dispose
    messageController.dispose();
    textFieldFocusNode.dispose();
    super.dispose();
  }

  Future<void> sendMessage(
      {required String message,
      required ChatProvider chatProvider,
      required bool isTextOnly}) async {
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

  //pick an image
  void pickImage() async {
    try {
      final pickedImages = await imagePicker.pickMultiImage(
        maxHeight: 800,
        maxWidth: 800,
        imageQuality: 95,
      );
      widget.chatProvider.setImageFilesList(filesList: pickedImages!);
    } catch (e) {
      print('error : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool hasImages = widget.chatProvider.imageFilesList.isNotEmpty &&
        widget.chatProvider.imageFilesList != null;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Theme.of(context).textTheme.labelLarge!.color!,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          if(hasImages) const PreviewImage(),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  //send image
                  if(hasImages){
                     widget.chatProvider.setImageFilesList(filesList: []);
                  }else{
                    pickImage();
                  }
                },
                icon: Icon(hasImages? Icons.delete : Icons.image),
              ),
              Expanded(
                child: TextField(
                  focusNode: textFieldFocusNode,
                  controller: messageController,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (String value) {
                    //chatProvider.sendMessage();
                    if (value.isNotEmpty) {
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
                  if (messageController.text.isNotEmpty) {
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
        ],
      ),
    );
  }
}
