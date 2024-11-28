import 'package:bloc_test/data/upload_from_device/upload_from_file_system/upload_file_exception.dart';
import 'package:file_picker/file_picker.dart';

class UploadFileProvider {
  Future<PlatformFile?> getFileFromFileSystem() async {
    try {
      final result = await FilePicker.platform.pickFiles();
      if (result != null) {
        final file = result.files.single;

        return file;
      } else {
        return null;
      }
    } catch (_) {
      throw UploadFileException();
    }
  }
}
