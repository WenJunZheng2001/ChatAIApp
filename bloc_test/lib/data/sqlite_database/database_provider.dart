import 'dart:io';

import 'package:bloc_test/data/sqlite_database/database_exception.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;
import 'dart:developer' show log;

import '../../model/upload_file_model.dart';

class DatabaseProvider {
  static Future<Database> getDatabaseReference() async {
    try {
      // Get a location using getDatabasesPath
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'messages.db');
      // open the database
      Database database = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        // When creating the db, create the table
        await db.execute(
          'CREATE TABLE Messages (id INTEGER PRIMARY KEY, isSentByMe INTEGER, text TEXT, data TEXT, filesFromUser TEXT, imagesFromAi TEXT)',
        );
      });
      return database;
    } catch (_) {
      throw DatabaseFailedToGetReferenceException();
    }
  }

  static Future<List<Map<String, Object?>>> getMessagesFromDatabase(
      {required Database database}) async {
    try {
      final list = await database.rawQuery('SELECT * FROM Messages');
      log("provider: $list");

      return list;
    } catch (_) {
      throw DatabaseFailedLoadException();
    }
  }

  static Future<void> deletedMessageFromDatabase(
      {required int id,
      required Database database,
      List<UploadFileIconModel>? listOfIconModel}) async {
    try {
      // Delete a record
      if (listOfIconModel != null && listOfIconModel.isNotEmpty) {
        for (final iconModel in listOfIconModel) {
          final localFilePath = iconModel.localFilePath;
          if (localFilePath != null) {
            await File(localFilePath).delete(recursive: true);
          }
        }
      }
      await database.rawDelete('DELETE FROM Messages WHERE id = ?', [id]);
      final list = await database.rawQuery('SELECT * FROM Messages');

      log(list.toString());
    } catch (_) {
      throw DatabaseFailedDeleteMessageException();
    }
  }

  static Future<int> insertMessageIntoDatabase(
      {required int isSentByMe,
      required String text,
      required Database database,
      required String dataOra,
      String? listOfIconDetailsFromUser,
      String? imagesFromAi}) async {
    try {
      int id = await database.rawInsert(
          'INSERT INTO Messages(isSentByMe, text, data, filesFromUser, imagesFromAi) VALUES(?, ?, ?, ?, ?)',
          [isSentByMe, text, dataOra, listOfIconDetailsFromUser, imagesFromAi]);

      return id;
    } catch (_) {
      throw DatabaseFailedAddMessageException();
    }
  }

  static Future<void> deleteAllMessagesFromDatabase(
      {required Database database}) async {
    try {
      await database.rawDelete("DELETE FROM Messages");
      final list = await database.rawQuery('SELECT * FROM Messages');
      final directory = await getApplicationDocumentsDirectory();
      final filesPath = "${directory.path}/files";
      await Directory(filesPath).create(recursive: true);
      Directory(filesPath).deleteSync(recursive: true);

      log(list.toString());
    } catch (_) {
      throw DatabaseFailedDeleteMessageException();
    }
  }

  static Future<void> deleteLocalDatabase() async {
    try {
      // Get a location using getDatabasesPath
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'messages.db');
      // Delete the database
      await deleteDatabase(path);

      final directory = await getApplicationDocumentsDirectory();
      final filesPath = "${directory.path}/files";
      await Directory(filesPath).create(recursive: true);
      Directory(filesPath).deleteSync(recursive: true);
    } catch (_) {
      throw DatabaseFailedDeleteMessageException();
    }
  }

  static Future<void> closeDatabase(Database database) async {
    await database.close();
  }
}
