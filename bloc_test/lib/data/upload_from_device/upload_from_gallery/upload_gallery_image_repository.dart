import 'dart:io';

import 'package:bloc_test/data/upload_from_device/upload_from_gallery/upload_gallery_image_exception.dart';
import 'package:bloc_test/data/upload_from_device/upload_from_gallery/upload_gallery_image_provider.dart';

import '../../../model/upload_file_model.dart';

class UploadGalleryImageRepository {
  Future<UploadFileModel?> getFileFromGallery() async {
    try {
      final file = await UploadGalleryImageProvider().getGalleryImageFile();
      if (file != null) {
        final fileName = file.name;

        UploadFileModel fileModel = UploadFileModel(
          fileIconDetails: UploadFileIconModel(
              iconToDisplay: file.path, isImage: true, fileName: fileName),
          file: File(file.path),
        );
        return fileModel;
      }
      return null;
    } catch (_) {
      throw UploadGalleryImageException();
    }
  }
}
