import 'package:flutter/material.dart';

class MessageUserTitle extends StatelessWidget {
  final bool isMessageSentByMe;
  const MessageUserTitle({super.key, required this.isMessageSentByMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isMessageSentByMe
          ? const EdgeInsets.only(top: 6, left: 5)
          : const EdgeInsets.only(top: 8.5, left: 5),
      child: Text(
        isMessageSentByMe ? "TU" : "AI",
      ),
    );
  }
}
