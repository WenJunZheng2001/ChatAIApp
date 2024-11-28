import 'package:bloc_test/utility/chat_utility/chat_message_text.dart';
import 'package:bloc_test/utility/chat_utility/clipboard_icon_button.dart';
import 'package:bloc_test/utility/chat_utility/delete_message_bin_icon.dart';
import 'package:bloc_test/utility/chat_utility/icona_messaggio_chat.dart';
import 'package:bloc_test/utility/chat_utility/message_divider.dart';
import 'package:bloc_test/utility/chat_utility/message_user_title.dart';
import 'package:bloc_test/utility/chat_utility/upload_file_image.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import '../../model/ui_message_class.dart';
import 'image_list_from_ai.dart';

class GroupedListViewChat extends StatelessWidget {
  final List<ChatMessage> messages;
  final String? photoUrl;

  const GroupedListViewChat(
      {super.key, required this.messages, required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return GroupedListView<ChatMessage, DateTime>(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      reverse: true,
      order: GroupedListOrder.DESC,
      useStickyGroupSeparators: true,
      floatingHeader: true,
      elements:
          messages.isEmpty ? [] : messages.take(messages.length - 1).toList(),
      groupBy: (message) => DateTime(
        DateTime.parse(message.data).year,
        DateTime.parse(message.data).month,
        DateTime.parse(message.data).day,
      ),
      groupHeaderBuilder: (ChatMessage message) => SizedBox(
        height: 40,
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                DateFormat.yMMMMd().format(DateTime.parse(message.data)),
              ),
            ),
          ),
        ),
      ),
      itemBuilder: (context, ChatMessage message) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconMessageChat(
                    isMessageSentByMe: message.isSentByMe,
                    photoUrl: photoUrl,
                    isAnimating: false,
                  ),
                  MessageUserTitle(isMessageSentByMe: message.isSentByMe),
                  const Spacer(),
                  message.isSentByMe
                      ? DeleteMessageBinIcon(
                          messageIndex: messages.indexOf(message),
                          id: message.id,
                          listOfIconModel: message.fileFromUser,
                        )
                      : ClipboardIconButton(textMessage: message.text),
                ],
              ),
              // TESTO
              Padding(
                padding: const EdgeInsets.only(left: 42.5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ChatMessageText(
                        messageText: message.text,
                      ),
                    ),
                    if (message.isSentByMe &&
                        (message.fileFromUser?.isNotEmpty ?? false))
                      UploadedFilePhoto(
                          listOfFileIcon: message.fileFromUser ?? []),
                  ],
                ),
              ),
              if (!message.isSentByMe &&
                  (message.imageUrlsFromAi?.isNotEmpty ?? false))
                ImageListFromAi(listOfImages: message.imageUrlsFromAi ?? []),
              if (!message.isSentByMe) const MessageDivider(),
            ],
          ),
        );
      },
    );
  }
}
