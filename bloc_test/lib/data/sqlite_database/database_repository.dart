import 'dart:io';

import 'package:bloc_test/data/sqlite_database/database_exception.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/ui_message_class.dart';
import '../../model/upload_file_model.dart';
import 'database_provider.dart';

class DatabaseRepository {
  static Future<List<ChatMessage>> getMessagesDatabase(
      {required Database database}) async {
    try {
      final listOfMap =
          await DatabaseProvider.getMessagesFromDatabase(database: database);
      final listOfNotes =
          ChatMessage.convertListOfMapsToListOfChatMessageModels(listOfMap);
      return listOfNotes;
    } catch (_) {
      throw DatabaseFailedLoadException();
    }
  }

  static Future<ChatMessage> addMessage(
      {required bool isSentByMe,
      required String text,
      required Database database,
      List<UploadFileModel>? fileAndImagesFromUser,
      List<String>? fileAndImagesFromAi}) async {
    try {
      List<UploadFileIconModel> lisOfFileIconFromUser = [];
      if (fileAndImagesFromUser != null && fileAndImagesFromUser.isNotEmpty) {
        final directory = await getApplicationDocumentsDirectory();
        final filesPath = "${directory.path}/files";
        await Directory(filesPath).create(recursive: true);
        for (final fileModel in fileAndImagesFromUser) {
          final file = fileModel.file;
          final String nameOfFIle = fileModel.fileIconDetails.fileName;
          final File copiedFile = await file.copy('$filesPath/$nameOfFIle');
          final isImage = fileModel.fileIconDetails.isImage;
          final fileIconModel = UploadFileIconModel(
              iconToDisplay: isImage
                  ? copiedFile.path
                  : fileModel.fileIconDetails.iconToDisplay,
              isImage: fileModel.fileIconDetails.isImage,
              fileName: nameOfFIle,
              localFilePath: copiedFile.path);
          lisOfFileIconFromUser.add(fileIconModel);
        }
      }

      String filesFromUser =
          UploadFileIconModel.uploadFileIconModelListToString(
              lisOfFileIconFromUser);
      String filesFromAi = fileAndImagesFromAi?.join(',') ?? '';

      // Insert some records in a transaction
      final dataOra = DateTime.now().toString();

      final id = await DatabaseProvider.insertMessageIntoDatabase(
        isSentByMe: isSentByMe ? 1 : 0,
        text: text,
        database: database,
        dataOra: dataOra,
        listOfIconDetailsFromUser: filesFromUser,
        imagesFromAi: filesFromAi,
      );

      final messageModel = ChatMessage(
        id: id,
        text: text,
        isSentByMe: isSentByMe,
        data: dataOra,
        fileFromUser: lisOfFileIconFromUser,
        imageUrlsFromAi: fileAndImagesFromAi,
      );

      return messageModel;
    } catch (_) {
      throw DatabaseFailedAddMessageException();
    }
  }
}
