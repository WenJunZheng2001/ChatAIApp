import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/chat_bloc/chat_bloc.dart';
import '../../bloc/chat_bloc/chat_state.dart';
import '../../model/upload_file_model.dart';
import 'delete_photo_or_file_button.dart';

class IconListToSend extends StatefulWidget {
  const IconListToSend({super.key});

  @override
  State<IconListToSend> createState() => _IconListToSendState();
}

class _IconListToSendState extends State<IconListToSend> {
  List<UploadFileModel> uploadListOfFileModel = [];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatSuccessUploadedFileState) {
          uploadListOfFileModel = state.iconsOfFileToSend;
        }
        if (state is ChatDeletedFileState) {
          uploadListOfFileModel = state.listOfIcons;
        }
        if (state is ChatSuccessfulStoredMessageToDbState) {
          uploadListOfFileModel = [];
        }
        if (state is ChatFailedSendMessageState) {
          uploadListOfFileModel = [];
        }
      },
      builder: (context, state) {
        if (uploadListOfFileModel.isNotEmpty) {
          return Container(
            width: 75,
            margin: const EdgeInsets.only(bottom: 60.0, top: 80),
            child: ListView.separated(
                shrinkWrap: true,
                reverse: true,
                itemCount: uploadListOfFileModel.length,
                separatorBuilder: (context, index) => const SizedBox(
                      height: 5.0,
                    ),
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      uploadListOfFileModel[index].fileIconDetails.isImage
                          ? Image.file(
                              File(uploadListOfFileModel[index]
                                  .fileIconDetails
                                  .iconToDisplay),
                            )
                          : Image.asset(uploadListOfFileModel[index]
                              .fileIconDetails
                              .iconToDisplay),
                      DeletePhotoOrFileButton(
                        fileIndex: index,
                      )
                    ],
                  );
                }),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
