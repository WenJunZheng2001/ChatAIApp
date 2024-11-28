import 'dart:developer' show log;

import 'package:bloc_test/data/fake_response_body.dart';
import 'package:bloc_test/model/upload_file_model.dart';
import 'package:http/http.dart' as https;
import 'message_exceptions.dart';

class MessageProvider {
  Future<String> sendMessageAndReadResponse(
      {required String userMessage,
      required String lisaMobileUrl,
      required String token,
      required List<UploadFileModel>? fileAndImagesFromUser,
      required bool isFileUploaded,
      required bool isAudioMessage}) async {
    try {
      /*
      var request = https.MultipartRequest('POST', Uri.parse(lisaMobileUrl));
      request.fields['userMessage'] = userMessage;
      request.fields["getAudio"] = isAudioMessage.toString();
      if (fileAndImagesFromUser != null && fileAndImagesFromUser.isNotEmpty) {
        for (final file in fileAndImagesFromUser) {
          request.files.add(await https.MultipartFile.fromPath(
              "fileFromUser", file.file.path));
        }
      }
      request.headers.addAll({
        "Content-type": "multipart/form-data",
        'Authorization': 'Bearer $token',
      });

      final streamedResponse = await request.send();
      var response = await https.Response.fromStream(streamedResponse);

      log(response.body);


      return response.body;

       */
      await Future.delayed(const Duration(seconds: 2));
      return fake_response;
    } catch (_) {
      throw MessageProviderException();
    }
  }
}
