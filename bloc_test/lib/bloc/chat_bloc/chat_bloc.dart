import 'package:bloc_test/data/sqlite_database/database_provider.dart';
import 'package:bloc_test/data/upload_from_device/access_camery_and_upload_photo/access_camera_repository.dart';
import 'package:bloc_test/data/message/message_repository.dart';
import 'package:bloc_test/data/upload_from_device/upload_from_file_system/upload_file_repository.dart';
import 'package:bloc_test/data/upload_from_device/upload_from_gallery/upload_gallery_image_repository.dart';
import 'package:bloc_test/model/upload_file_model.dart';
import 'package:bloc_test/data/auth/auth_service.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sqflite/sqflite.dart' show Database;

import '../../data/sqlite_database/database_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  //final String lisaMobileUrl = dotenv.env['LISA_MOBILE_URL'] ?? "";
  final String lisaMobileUrl = "fake_url";
  bool isFileOrPhotoUploaded = false;
  String? token;
  List<UploadFileModel> fileAndImagesFromUser = [];
  late Database database;
  bool isDoingSomething = false;

  ChatBloc() : super(ChatInitialState()) {
    on<ChatStartUpLoadMessageEvent>((event, emit) async {
      try {
        emit(ChatLoadingState());
        database = await DatabaseProvider.getDatabaseReference();
        final messages =
            await DatabaseRepository.getMessagesDatabase(database: database);
        emit(ChatSuccessStartUpLoadMessageState(messages: messages));
      } catch (e) {
        emit(ChatErrorState(e.toString()));
      }
    });

    on<ChatSendingMessageEvent>((event, emit) async {
      try {
        if (lisaMobileUrl == "") {
          return;
        }
        if (isDoingSomething) {
          return;
        }

        if (event.message.isEmpty && fileAndImagesFromUser.isEmpty) {
          return;
        }

        isDoingSomething = true;

        final userMessage = await DatabaseRepository.addMessage(
            isSentByMe: true,
            text: event.message.isEmpty ? "" : event.message,
            database: database,
            fileAndImagesFromUser: fileAndImagesFromUser);

        emit(ChatSuccessfulStoredMessageToDbState(userMessage: userMessage));

        token ??= await AuthService.firebase().getIdToken();
        String readyToken = "";
        if (token != null) {
          readyToken = token as String;
        }

        final responseModel = await MessageRepository().getAiResponse(
          userMessage: event.message,
          lisaMobileUrl: lisaMobileUrl,
          token: readyToken,
          isFileUploaded: isFileOrPhotoUploaded,
          fileAndImagesFromUser: fileAndImagesFromUser,
          isAudioMessage: false,
        );

        isFileOrPhotoUploaded = false;
        // filesToSendBase64 = [];
        // typesOfTheFileToSend = [];
        // iconsOfFileToSend = [];
        fileAndImagesFromUser = [];
        //waiting state da aggiungere

        final aiMessage = await DatabaseRepository.addMessage(
          isSentByMe: false,
          text: responseModel.answer,
          database: database,
          fileAndImagesFromAi: responseModel.imageUrls,
        );
        // fileAndImagesFromAi: responseModel.imageUrls);
        emit(ChatSuccessResponseReceivedState(aiMessage: aiMessage));
        isDoingSomething = false;
      } catch (_) {
        try {
          fileAndImagesFromUser = [];
          isFileOrPhotoUploaded = false;
          final errorMessage = await DatabaseRepository.addMessage(
            isSentByMe: false,
            text: "Abbiamo avuto un problema.",
            database: database,
          );
          emit(ChatFailedSendMessageState(errorMessage: errorMessage));
          isDoingSomething = false;
        } catch (_) {
          emit(ChatErrorState("Errore del database"));
          print("trovato");
        }
      }
    });

    on<ChatUploadFileEvent>((event, emit) async {
      if (isDoingSomething == true) {
        return;
      }
      try {
        isDoingSomething = true;
        emit(ChatLoadingState());
        final fileModel =
            await UploadFileRepository().uploadFileAndGetDetails();
        if (fileModel == null) {
          emit(ChatFailedUploadFileState());
        } else {
          fileAndImagesFromUser.add(fileModel);
          isFileOrPhotoUploaded = true;
          emit(ChatSuccessUploadedFileState(
            iconsOfFileToSend: fileAndImagesFromUser,
          ));
        }
        isDoingSomething = false;
      } catch (e) {
        emit(ChatErrorState(e.toString()));
      }
    });

    on<ChatAccessCameraEvent>((event, emit) async {
      if (isDoingSomething == true) {
        return;
      }
      try {
        isDoingSomething = true;
        emit(ChatLoadingState());
        final fileModel =
            await AccessCameraRepository().getPhotoFileFromCamera();
        if (fileModel == null) {
          emit(ChatFailedUploadFileState());
        } else {
          fileAndImagesFromUser.add(fileModel);
          isFileOrPhotoUploaded = true;
          emit(ChatSuccessUploadedFileState(
            iconsOfFileToSend: fileAndImagesFromUser,
          ));
        }
        isDoingSomething = false;
      } catch (e) {
        emit(ChatErrorState(e.toString()));
      }
    });

    on<ChatUploadImageEvent>((event, emit) async {
      if (isDoingSomething == true) {
        return;
      }
      try {
        isDoingSomething = true;
        emit(ChatLoadingState());

        final fileModel =
            await UploadGalleryImageRepository().getFileFromGallery();
        if (fileModel == null) {
          emit(ChatFailedUploadFileState());
        } else {
          fileAndImagesFromUser.add(fileModel);
          isFileOrPhotoUploaded = true;
          emit(ChatSuccessUploadedFileState(
            iconsOfFileToSend: fileAndImagesFromUser,
          ));
          // }
        }
        isDoingSomething = false;
      } catch (e) {
        emit(ChatErrorState(e.toString()));
      }
    });

    on<ChatDeleteSelectedFileEvent>((event, emit) {
      if (isDoingSomething == true) {
        return;
      }
      isDoingSomething = true;
      fileAndImagesFromUser.removeAt(event.fileIndex);
      if (fileAndImagesFromUser == []) {
        isFileOrPhotoUploaded = false;
      }
      emit(ChatDeletedFileState(listOfIcons: fileAndImagesFromUser));
      isDoingSomething = false;
    });

    on<ChatDeleteChatEvent>((event, emit) async {
      if (isDoingSomething == true) {
        return;
      }
      try {
        isDoingSomething = true;
        await DatabaseProvider.deleteAllMessagesFromDatabase(
            database: database);
        emit(ChatDeletedChatState());
        isDoingSomething = false;
      } catch (_) {
        emit(ChatErrorState("Eliminazione fallita"));
      }
    });

    on<ChatDeleteQuestionEvent>((event, emit) async {
      if (isDoingSomething == true) {
        return;
      }
      try {
        isDoingSomething = true;
        await DatabaseProvider.deletedMessageFromDatabase(
            id: event.id,
            database: database,
            listOfIconModel: event.listOfIconModel);
        await DatabaseProvider.deletedMessageFromDatabase(
            id: event.id + 1, database: database);
        emit(ChatDeletedQuestionState(messageIndex: event.messageIndex));
        isDoingSomething = false;
      } catch (_) {
        emit(ChatErrorState("Eliminazione fallita"));
      }
    });

    on<ChatCloseDatabaseEvent>((event, emit) async {
      if (isDoingSomething == true) {
        return;
      }
      try {
        isDoingSomething = true;
        await DatabaseProvider.closeDatabase(database);
        emit(ChatSuccessClosingDatabaseState());
        isDoingSomething = false;
      } catch (e) {
        emit(ChatErrorState("Fail chiusura del database"));
      }
    });
  }

  @override
  Future<void> close() async {
    await database.close();
    return super.close();
  }
}
