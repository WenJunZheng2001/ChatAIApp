import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bloc_test/utility/chat_utility/clipboard_icon_button.dart';
import 'package:bloc_test/utility/chat_utility/delete_message_bin_icon.dart';
import 'package:bloc_test/utility/chat_utility/icona_messaggio_chat.dart';
import 'package:bloc_test/utility/chat_utility/message_divider.dart';
import 'package:bloc_test/utility/chat_utility/message_user_title.dart';
import 'package:bloc_test/utility/chat_utility/upload_file_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/chat_bloc/chat_bloc.dart';
import '../../bloc/chat_bloc/chat_state.dart';
import '../../model/ui_message_class.dart';
import 'chat_message_text.dart';
import 'image_list_from_ai.dart';

class LastMessageUi extends StatefulWidget {
  final ChatMessage lastMessage;
  final bool isAnimatingTypewriter;
  final String? photoUrl;

  const LastMessageUi(
      {super.key,
      required this.lastMessage,
      required this.isAnimatingTypewriter,
      required this.photoUrl});

  @override
  State<LastMessageUi> createState() => _LastMessageUiState();
}

class _LastMessageUiState extends State<LastMessageUi> {
  late bool isAnimating;

  @override
  void initState() {
    super.initState();
    isAnimating = widget.isAnimatingTypewriter;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatSuccessfulStoredMessageToDbState) {
          isAnimating = true;
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconMessageChat(
                  isMessageSentByMe: widget.lastMessage.isSentByMe,
                  photoUrl: widget.photoUrl,
                  isAnimating: isAnimating,
                ),
                MessageUserTitle(
                    isMessageSentByMe: widget.lastMessage.isSentByMe),
                const Spacer(),
                widget.lastMessage.isSentByMe
                    ? const DeleteMessageBinIcon()
                    : ClipboardIconButton(textMessage: widget.lastMessage.text),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 42.5),
              child: !widget.lastMessage.isSentByMe && isAnimating
                  ? AnimatedTextKit(
                      onFinished: () {
                        setState(() {
                          isAnimating = false;
                        });
                      },
                      displayFullTextOnTap: true,
                      totalRepeatCount: 1,
                      animatedTexts: [
                        TyperAnimatedText(widget.lastMessage.text),
                      ],
                      onTap: () {
                        setState(() {
                          isAnimating = false;
                        });
                      },
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ChatMessageText(
                            messageText: widget.lastMessage.text,
                          ),
                        ),
                        if (widget.lastMessage.isSentByMe &&
                            (widget.lastMessage.fileFromUser?.isNotEmpty ??
                                false))
                          UploadedFilePhoto(
                              listOfFileIcon:
                                  widget.lastMessage.fileFromUser ?? []),
                      ],
                    ),
            ),
            if (!widget.lastMessage.isSentByMe &&
                (widget.lastMessage.imageUrlsFromAi?.isNotEmpty ?? false) &&
                !isAnimating)
              ImageListFromAi(
                listOfImages: widget.lastMessage.imageUrlsFromAi ?? [],
              ),
            if (!widget.lastMessage.isSentByMe) const MessageDivider(),
          ],
        ),
      ),
    );
  }
}
