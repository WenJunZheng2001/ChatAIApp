import 'package:bloc_test/model/upload_file_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/chat_bloc/chat_bloc.dart';
import '../../bloc/chat_bloc/chat_event.dart';
import '../dialog_utility/show_bool_dialog.dart';

class DeleteMessageBinIcon extends StatelessWidget {
  final int? messageIndex;
  final int? id;
  final List<UploadFileIconModel>? listOfIconModel;
  const DeleteMessageBinIcon(
      {super.key, this.messageIndex, this.id, this.listOfIconModel});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.delete,
        size: 20,
      ),
      onPressed: () async {
        final messageIndex = this.messageIndex;
        final id = this.id;
        if (messageIndex != null && id != null) {
          final shouldDelete = await showBoolDialog(
              context, "Eliminare quesito?", "Non puoi recuperarla in seguito");
          if (shouldDelete) {
            if (context.mounted) {
              context.read<ChatBloc>().add(ChatDeleteQuestionEvent(
                    messageIndex: messageIndex,
                    id: id,
                    listOfIconModel: listOfIconModel,
                  ));
            }
          }
        }
      },
    );
  }
}
