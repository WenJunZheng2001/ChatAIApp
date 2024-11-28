import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClipboardIconButton extends StatelessWidget {
  final String textMessage;
  const ClipboardIconButton({super.key, required this.textMessage});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.content_copy,
        size: 20,
      ),
      onPressed: () {
        Clipboard.setData(ClipboardData(text: textMessage));
      },
    );
  }
}
