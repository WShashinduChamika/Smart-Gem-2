import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_gem/models/model.dart';
import 'package:smart_gem/providers/chat_provider.dart';

class PreviewImage extends StatelessWidget {
  const PreviewImage({super.key, this.message});

  final Message? message;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(builder: (context, chatProvider, child) {
      final messageToShow =
          message != null ? message!.imageUrls : chatProvider.imageFilesList;
      final padding = message != null
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(horizontal: 8);

      return Padding(
        padding: padding,
        child: SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: messageToShow.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(4.0, 8.0, 4.0, 0.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(
                      File(message != null
                          ? message!.imageUrls[index]
                          : chatProvider.imageFilesList[index].path),
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            )),
      );
    });
  }
}
