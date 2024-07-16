import 'package:flutter/material.dart';

void showAnimatedDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String actionText,
  required Function(bool) actionPressed,
}) async {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Container();
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: Tween<double>(begin: 0.5, end: 1).animate(animation),
        child: FadeTransition(
          opacity: animation,
          child: AlertDialog(
            title: Text(
              title,
              textAlign: TextAlign.center,
            ),
            content: Text(
              content,
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  actionPressed(false);
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  actionPressed(true);
                  Navigator.of(context).pop();
                },
                child: Text(actionText),
              ),
            ],
          ),
        ),
      );
    },
  );
}
