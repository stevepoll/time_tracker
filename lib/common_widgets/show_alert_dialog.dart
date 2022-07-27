import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<dynamic> showAlertDialog(
  BuildContext context, {
  required String title,
  required String content,
  required String defaultActionText,
  String? cancelActionText,
}) {
  if (!Platform.isIOS) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            if (cancelActionText != null)
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(cancelActionText),
              ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(defaultActionText),
            )
          ],
        );
      },
    );
  } else {
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            if (cancelActionText != null)
              CupertinoDialogAction(
                onPressed: () => Navigator.pop(context, false),
                child: Text(cancelActionText),
              ),
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context, true),
              child: Text(defaultActionText),
            )
          ],
        );
      },
    );
  }
}
