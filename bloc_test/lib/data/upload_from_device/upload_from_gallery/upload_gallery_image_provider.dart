import 'package:bloc_test/data/upload_from_device/upload_from_gallery/upload_gallery_image_exception.dart';
import 'package:image_picker/image_picker.dart';

class UploadGalleryImageProvider {
  Future<XFile?> getGalleryImageFile() async {
    try {
      // Logica per caricare l'immagine dal telefono
      final picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        return pickedFile;
      } else {
        // L'utente ha annullato la selezione dell'immagine
        return null;
      }
    } catch (_) {
      // Gestisci eventuali errori
      throw UploadGalleryImageException();
    }
  }
}
