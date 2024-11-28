import 'package:flutter/material.dart';

class ChatMessageText extends StatelessWidget {
  final String messageText;
  const ChatMessageText({super.key, required this.messageText});

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      messageText,
      onSelectionChanged: (selection, cause) {},
    );
  }
}
