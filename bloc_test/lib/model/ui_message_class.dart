import 'package:bloc_test/model/upload_file_model.dart';

class ChatMessage {
  final int id;
  final String text;
  final String data;
  final bool isSentByMe;
  final List<String>? imageUrlsFromAi;
  final List<UploadFileIconModel>? fileFromUser;

  static List<ChatMessage> convertListOfMapsToListOfChatMessageModels(
      List<Map<String, Object?>> listOfNotes) {
    return listOfNotes
        .map((messageMap) => ChatMessage(
              id: messageMap['id'] as int,
              text: messageMap['text'] as String,
              isSentByMe: messageMap['isSentByMe'] == 1 ? true : false,
              data: messageMap['data'] as String,
              fileFromUser: UploadFileIconModel.stringToUploadFileIconModelList(
                  messageMap['filesFromUser'].toString()),
              imageUrlsFromAi: messageMap['imagesFromAi'] == "" ||
                      messageMap['imagesFromAi'] == null
                  ? null
                  : messageMap['imagesFromAi'].toString().split(','),
            ))
        .toList();
  }

//<editor-fold desc="Data Methods">
  const ChatMessage({
    required this.id,
    required this.text,
    required this.data,
    required this.isSentByMe,
    this.imageUrlsFromAi,
    this.fileFromUser,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatMessage &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          text == other.text &&
          data == other.data &&
          isSentByMe == other.isSentByMe &&
          imageUrlsFromAi == other.imageUrlsFromAi &&
          fileFromUser == other.fileFromUser);

  @override
  int get hashCode =>
      id.hashCode ^
      text.hashCode ^
      data.hashCode ^
      isSentByMe.hashCode ^
      imageUrlsFromAi.hashCode ^
      fileFromUser.hashCode;

  @override
  String toString() {
    return 'ChatMessage{ id: $id, text: $text, data: $data, isSentByMe: $isSentByMe, imageUrlsFromAi: $imageUrlsFromAi, fileFromUser: $fileFromUser,}';
  }

  ChatMessage copyWith({
    int? id,
    String? text,
    String? data,
    bool? isSentByMe,
    List<String>? imageUrlsFromAi,
    List<UploadFileIconModel>? fileFromUser,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      data: data ?? this.data,
      isSentByMe: isSentByMe ?? this.isSentByMe,
      imageUrlsFromAi: imageUrlsFromAi ?? this.imageUrlsFromAi,
      fileFromUser: fileFromUser ?? this.fileFromUser,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'data': data,
      'isSentByMe': isSentByMe,
      'imageUrlsFromAi': imageUrlsFromAi,
      'fileFromUser': fileFromUser,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] as int,
      text: map['text'] as String,
      data: map['data'] as String,
      isSentByMe: map['isSentByMe'] as bool,
      imageUrlsFromAi: map['imageUrlsFromAi'] as List<String>,
      fileFromUser: map['fileFromUser'] as List<UploadFileIconModel>,
    );
  }

//</editor-fold>
}
