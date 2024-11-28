import 'package:bloc_test/model/upload_file_model.dart';

import '../../model/ui_message_class.dart';

abstract class ChatState {}

class ChatInitialState extends ChatState {}

class ChatSuccessResponseReceivedState extends ChatState {
  ChatMessage aiMessage;

  ChatSuccessResponseReceivedState({required this.aiMessage});
}

class ChatSuccessUploadedFileState extends ChatState {
  final List<UploadFileModel> iconsOfFileToSend;

  ChatSuccessUploadedFileState({required this.iconsOfFileToSend});
}

class ChatFailedSendMessageState extends ChatState {
  final ChatMessage errorMessage;
  ChatFailedSendMessageState({required this.errorMessage});
}

class ChatFailedUploadFileState extends ChatState {}

class ChatErrorState extends ChatState {
  final String error;
  ChatErrorState(this.error);
}

class ChatSuccessfulStoredMessageToDbState extends ChatState {
  final ChatMessage userMessage;
  ChatSuccessfulStoredMessageToDbState({required this.userMessage});
}

class ChatLoadingState extends ChatState {}

class ChatDeletedChatState extends ChatState {}

class ChatDeletedQuestionState extends ChatState {
  final int messageIndex;
  ChatDeletedQuestionState({required this.messageIndex});
}

class ChatDeletedFileState extends ChatState {
  final List<UploadFileModel> listOfIcons;

  ChatDeletedFileState({required this.listOfIcons});
}

class ChatSuccessStartUpLoadMessageState extends ChatState {
  final List<ChatMessage> messages;

  ChatSuccessStartUpLoadMessageState({required this.messages});
}

class ChatSuccessClosingDatabaseState extends ChatState {}
