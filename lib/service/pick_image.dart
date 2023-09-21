import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

class PickImage {
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imageTemp = File(image.path);

      Uint8List? imageBytes = await imageTemp.readAsBytes();
      return imageBytes;
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickImageCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      if (image == null) return;

      final imageTemp = File(image.path);

      Uint8List? imageBytes = await imageTemp.readAsBytes();
      return imageBytes;
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  ShowImage(imageBytes) {
    return imageBytes != null
        ? Image.memory(
            imageBytes ?? Uint8List(0),
            fit: BoxFit.cover,
          )
        : Text("data");
  }
}
