import 'package:flutter/material.dart';

Future<bool> showBoolDialog(
    BuildContext context, String title, String content) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Si"),
            ),
          ],
        );
      }).then((value) => value ?? false);
}
