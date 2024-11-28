import 'package:bloc_test/bloc/chat_bloc/chat_bloc.dart';
import 'package:bloc_test/utility/dialog_utility/show_bool_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/chat_bloc/chat_event.dart';

class DeleteChatBinIcon extends StatelessWidget {
  const DeleteChatBinIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: FloatingActionButton(
        shape: const CircleBorder(),
        mini: true, // Imposta mini su true per un pulsante più piccolo
        onPressed: () async {
          final shouldDelete = await showBoolDialog(
              context, "Eliminare chat?", "Non puoi recuperarla in seguito");
          if (shouldDelete) {
            if (context.mounted) {
              context.read<ChatBloc>().add(ChatDeleteChatEvent());
            }
          }
        },
        child: const Icon(
          Icons.delete,
        ),
      ),
    );
  }
}
