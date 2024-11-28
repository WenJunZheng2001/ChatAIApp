import 'package:bloc_test/bloc/chat_bloc/chat_event.dart';
import 'package:bloc_test/bloc/chat_bloc/chat_state.dart';
import 'package:bloc_test/utility/chat_utility/chat_send_message_button.dart';
import 'package:bloc_test/utility/chat_utility/grouped_list_view_chat.dart';
import 'package:bloc_test/utility/chat_utility/last_message_ui.dart';
import 'package:bloc_test/utility/dialog_utility/speed_dial_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../bloc/chat_bloc/chat_bloc.dart';
import '../model/ui_message_class.dart';
import '../utility/dialog_utility/show_bool_dialog.dart';
import '../utility/home_utility/icon_list_of_file_to_send.dart';

class ChatContent extends StatefulWidget {
  final String? photoUrl;

  const ChatContent({super.key, required this.photoUrl});

  @override
  State<ChatContent> createState() => _ChatContentState();
}

class _ChatContentState extends State<ChatContent> {
  late TextEditingController _textEditingController;
  late ScrollController _scrollController;

  List<ChatMessage> messages = [];

  String response = "Ciao";
  bool isLoading = false;
  bool isScrolling = false;
  bool isAnimatingTypewriter = false;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _scrollController = ScrollController();
    context.read<ChatBloc>().add(ChatStartUpLoadMessageEvent());
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(
          "Chat",
        ),
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        actions: [
          IconButton(
            tooltip: "Delete Chat",
            onPressed: () async {
              final shouldDelete = await showBoolDialog(context,
                  "Eliminare chat?", "Non puoi recuperarla in seguito");
              if (shouldDelete) {
                if (context.mounted) {
                  context.read<ChatBloc>().add(ChatDeleteChatEvent());
                }
              }
            },
            icon: const Icon(
              Icons.delete,
            ),
          ),
        ],
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatLoadingState) {
            context.loaderOverlay.show();
          } else {
            context.loaderOverlay.hide();
          }
          if (state is ChatSuccessStartUpLoadMessageState) {
            messages = state.messages;
          }
          if (state is ChatSuccessfulStoredMessageToDbState) {
            _textEditingController.clear();
            messages.add(state.userMessage);
            isLoading = true;
            isAnimatingTypewriter = true;
          } else {
            isLoading = false;
          }
          if (state is ChatSuccessResponseReceivedState) {
            messages.add(state.aiMessage);
          }
          if (state is ChatFailedSendMessageState) {
            messages.add(state.errorMessage);
          }

          if (state is ChatDeletedChatState) {
            messages = [];
          }
          if (state is ChatDeletedQuestionState) {
            messages.removeRange(state.messageIndex, state.messageIndex + 2);
          }
        },
        builder: (context, state) {
          //mostra qualcosa in caso di errori gravi
          if (state is ChatErrorState) {
            return Column(
              children: [Text(state.error)],
            );
          }
          //contenuto se tutto va bene
          return Column(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const ScrollPhysics(),
                    reverse: true,
                    child: Column(
                      children: [
                        if (messages.length > 1)
                          GroupedListViewChat(
                            messages: messages,
                            photoUrl: widget.photoUrl,
                          ),
                        //last message
                        if (messages.isNotEmpty)
                          LastMessageUi(
                            lastMessage: messages.last,
                            isAnimatingTypewriter: isAnimatingTypewriter,
                            photoUrl: widget.photoUrl,
                          ),
                        if (isLoading)
                          SpinKitThreeBounce(
                            size: 20,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: Row(
                  children: [
                    const SpeedDialButton(),
                    // const AnimatedPopup(),
                    const SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      child: TextField(
                        onTapOutside: (event) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          filled: true,
                          hintText: "Write your question here...",
                          hintStyle: const TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    ChatSendMessageButton(
                      messageController: _textEditingController,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: const IconListToSend(),
    );
  }
}
