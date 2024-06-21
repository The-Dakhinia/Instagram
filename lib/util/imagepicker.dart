import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerr {
  final ImagePicker _picker = ImagePicker();

  Future<File?> uploadImage(String inputSource) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: inputSource == 'Camera' ? ImageSource.camera : ImageSource.gallery,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      } else {
        return null;
      }
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }
}
