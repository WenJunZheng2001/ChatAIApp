import 'package:bloc_test/bloc/chat_bloc/chat_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../bloc/chat_bloc/chat_bloc.dart';

class SpeedDialButton extends StatelessWidget {
  const SpeedDialButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      heroTag: "speedDialChat",
      buttonSize: const Size(50, 50),
      // childPadding: const EdgeInsets.only(left: 5),
      animationDuration: const Duration(milliseconds: 375),
      childrenButtonSize: const Size(50, 50),
      spacing: 3,
      icon: Icons.add,
      activeIcon: Icons.close,
      overlayColor: Colors.black,
      overlayOpacity: 0,
      animationCurve: Curves.elasticInOut,
      // openCloseDial: isDialOpen,
      children: [
        SpeedDialChild(
          shape: const CircleBorder(),
          child: const Icon(
            Icons.file_upload,
          ),
          onTap: () => context.read<ChatBloc>().add(ChatUploadFileEvent()),
        ),
        SpeedDialChild(
          shape: const CircleBorder(),
          child: const Icon(
            Icons.image,
          ),
          onTap: () => context.read<ChatBloc>().add(ChatUploadImageEvent()),
        ),
        SpeedDialChild(
          shape: const CircleBorder(),
          child: const Icon(
            Icons.camera_alt,
          ),
          onTap: () => context.read<ChatBloc>().add(ChatAccessCameraEvent()),
        ),
      ],
    );
  }
}
