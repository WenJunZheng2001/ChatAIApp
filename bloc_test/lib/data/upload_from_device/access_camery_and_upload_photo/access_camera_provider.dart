import 'package:bloc_test/data/upload_from_device/access_camery_and_upload_photo/device_camera_exceptions.dart';
import 'package:image_picker/image_picker.dart';

class AccessCameraProvider {
  Future<XFile?> accessCameraAndTakePhoto() async {
    try {
      final picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        return pickedFile;
      } else {
        return null;
      }
    } catch (_) {
      throw DeviceCameraException();
    }
  }
}
