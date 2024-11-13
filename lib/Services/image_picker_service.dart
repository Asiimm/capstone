// image_picker_service.dart
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final picker = ImagePicker();

  // Method to pick an image from the gallery
  Future<File?> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      print('No image selected.');
      return null;
    }
  }

  // Method to remove the image
  void removeImage(File? image) {
    if (image != null) {
      print('Image removed.');
      image.delete();
    }
  }
}
