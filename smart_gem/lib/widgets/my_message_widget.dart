import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:smart_gem/models/model.dart';
import 'package:smart_gem/widgets/preview_images.dart';

class MyMessages extends StatelessWidget {

  const MyMessages({super.key, required this.message});
  final Message message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child:Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(18),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message.imageUrls.isNotEmpty)
                PreviewImage(
                  message: message,
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                child: MarkdownBody(
                  selectable: true,
                  data: message.message.toString(),
                ),
              ),
            ],
          )
      ),
    );
  }
}
