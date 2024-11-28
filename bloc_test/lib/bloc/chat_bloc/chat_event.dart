import '../../model/upload_file_model.dart';

sealed class ChatEvent {}

class ChatSendingMessageEvent extends ChatEvent {
  final String message;

  ChatSendingMessageEvent({required this.message});
}

class ChatUploadImageEvent extends ChatEvent {}

class ChatUploadFileEvent extends ChatEvent {}

class ChatAccessCameraEvent extends ChatEvent {}

class ChatDeleteSelectedFileEvent extends ChatEvent {
  final int fileIndex;

  ChatDeleteSelectedFileEvent({required this.fileIndex});
}

class ChatDeleteChatEvent extends ChatEvent {}

class ChatDeleteQuestionEvent extends ChatEvent {
  final int messageIndex;
  final int id;
  final List<UploadFileIconModel>? listOfIconModel;

  ChatDeleteQuestionEvent({
    required this.messageIndex,
    required this.id,
    this.listOfIconModel,
  });
}

class ChatStartUpLoadMessageEvent extends ChatEvent {}

class ChatCloseDatabaseEvent extends ChatEvent {}
