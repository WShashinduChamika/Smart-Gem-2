import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AssistanceMessage extends StatelessWidget {
  const AssistanceMessage({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant ,
          borderRadius: BorderRadius.circular(18),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: message.isEmpty
            ? const SizedBox(
                height: 20,
                width: 50,
                child: SpinKitThreeBounce(
                  color: Colors.blueGrey,
                  size: 20,
                ),
              )
            : MarkdownBody(
                selectable: true,
                data: message,
              ),
      ),
    );
  }
}
