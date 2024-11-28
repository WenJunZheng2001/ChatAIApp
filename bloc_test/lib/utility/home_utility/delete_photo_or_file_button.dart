import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/chat_bloc/chat_bloc.dart';
import '../../bloc/chat_bloc/chat_event.dart';

class DeletePhotoOrFileButton extends StatelessWidget {
  final int fileIndex;
  const DeletePhotoOrFileButton({super.key, required this.fileIndex});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      child: GestureDetector(
        onTap: () => context
            .read<ChatBloc>()
            .add(ChatDeleteSelectedFileEvent(fileIndex: fileIndex)),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: const Icon(
            Icons.close,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
