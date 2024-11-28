import 'dart:convert';

import 'package:bloc_test/data/message/message_data_provider.dart';
import 'package:bloc_test/model/response_from_ai_model.dart';

import '../../model/upload_file_model.dart';
import 'message_exceptions.dart';

class MessageRepository {
  Future<AiResponseModel> getAiResponse(
      {required String userMessage,
      required String lisaMobileUrl,
      required String token,
      required List<UploadFileModel>? fileAndImagesFromUser,
      required bool isFileUploaded,
      required bool isAudioMessage}) async {
    try {
      final responseBody = await MessageProvider().sendMessageAndReadResponse(
        userMessage: userMessage,
        lisaMobileUrl: lisaMobileUrl,
        token: token,
        isFileUploaded: isFileUploaded,
        fileAndImagesFromUser: fileAndImagesFromUser,
        isAudioMessage: isAudioMessage,
      );
      print("ci arrivo");
      final Map<String, dynamic> data = jsonDecode(
        responseBody,
      );
      print("tap 2");
      final aiResponseModel = AiResponseModel.fromMap(data);
      print("tap3");
      return aiResponseModel;
    } catch (_) {
      throw MessageRepositoryException();
    }
  }
}
