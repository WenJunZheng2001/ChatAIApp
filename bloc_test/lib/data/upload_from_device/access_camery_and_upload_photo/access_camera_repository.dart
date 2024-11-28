import 'dart:io';

import 'package:bloc_test/data/upload_from_device/access_camery_and_upload_photo/device_camera_exceptions.dart';
import 'package:bloc_test/data/upload_from_device/access_camery_and_upload_photo/access_camera_provider.dart';

import '../../../model/upload_file_model.dart';

class AccessCameraRepository {
  Future<UploadFileModel?> getPhotoFileFromCamera() async {
    try {
      final pickedFile =
          await AccessCameraProvider().accessCameraAndTakePhoto();
      if (pickedFile != null) {
        final filePath = pickedFile.path;
        final fileName = pickedFile.name;
        UploadFileModel fileModel = UploadFileModel(
            fileIconDetails: UploadFileIconModel(
                iconToDisplay: filePath, isImage: true, fileName: fileName),
            file: File(filePath));
        return fileModel;
      } else {
        return null;
      }
    } catch (_) {
      throw DeviceCameraException();
    }
  }
}
