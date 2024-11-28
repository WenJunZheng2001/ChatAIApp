import 'dart:io';

import 'package:bloc_test/data/upload_from_device/upload_from_file_system/upload_file_exception.dart';
import 'package:bloc_test/data/upload_from_device/upload_from_file_system/upload_file_provider.dart';

import '../../../constants/file_extension_constants.dart';
import '../../../model/upload_file_model.dart';

class UploadFileRepository {
  Future<UploadFileModel?> uploadFileAndGetDetails() async {
    try {
      final platformFile = await UploadFileProvider().getFileFromFileSystem();
      final filePath = platformFile?.path;

      if (platformFile == null || filePath == null) {
        return null;
      } else {
        String fileName = platformFile.name;
        final fileExtension = fileName.split('.').last.toLowerCase();

        final fileIconMap = {
          'pdf': pdfIcon,
          'doc': docIcon,
          'docx': docxIcon,
          'xls': xlsIcon,
          'xlsx': xlsxIcon,
          'ppt': pptIcon,
          'pptx': pptxIcon,
          'ai': aiIcon,
          'css': cssIcon,
          'html': htmlIcon,
          'htm': htmlIcon,
          'id': idIcon,
          'jpg': jpgIcon,
          'jpeg': jpegIcon,
          'js': jsIcon,
          'mp3': mp3Icon,
          'mp4': mp4Icon,
          'php': phpIcon,
          'png': pngIcon,
          'psd': psdIcon,
          'tiff': tiffIcon,
          'txt': txtIcon,
          'opus': opusIcon,
          'm4a': m4aIcon,
          'ogg': oggIcon,
          // Aggiungi altre estensioni di file e i loro percorsi delle immagini qui
        };

        // Ottieni il percorso dell'immagine corrispondente all'estensione del file
        String? selectedFileIcon = fileIconMap[fileExtension];

        UploadFileModel fileModel = UploadFileModel(
            fileIconDetails: UploadFileIconModel(
                iconToDisplay: selectedFileIcon ?? jpgIcon,
                isImage: false,
                fileName: fileName),
            file: File(filePath));
        return fileModel;
      }
    } catch (_) {
      throw UploadFileException();
    }
  }
}
