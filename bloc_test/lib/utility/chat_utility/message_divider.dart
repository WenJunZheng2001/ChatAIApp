import 'package:flutter/material.dart';

class MessageDivider extends StatelessWidget {
  const MessageDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4, left: 42.5),
      height: 1,
      width: double.infinity,
      color: Colors.grey[300],
    );
  }
}
