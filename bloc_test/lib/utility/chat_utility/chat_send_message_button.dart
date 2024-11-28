import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../bloc/chat_bloc/chat_bloc.dart';
import '../../bloc/chat_bloc/chat_event.dart';
import '../../constants/image_constants.dart';

class ChatSendMessageButton extends StatelessWidget {
  final TextEditingController messageController;
  const ChatSendMessageButton({super.key, required this.messageController});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.8,
      child: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () => context
            .read<ChatBloc>()
            .add(ChatSendingMessageEvent(message: messageController.text)),
        child: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: SvgPicture.asset(
            sendIcon,
            width: 24,
            height: 24,
          ),
        ),
      ),
    );
  }
}
