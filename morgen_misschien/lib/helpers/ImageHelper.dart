
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';


class ImageHelper {
  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.fill,
    );
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }

static Future<bool> pickImageAndSave(String imagePath) async {
    imageCache.clear();

    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) { return false; }

    final String folderPath = (await getApplicationDocumentsDirectory()).path;

    // bool bAlreadyExists =

    await image.saveTo(fullImagePath(folderPath, imagePath));
    return true;
}

static String imagePath(String firstName, String lastName) {
    return '$firstName-$lastName';
}

static String fullImagePath(String folderPath, String imagePath) {
    return '$folderPath/$imagePath';
}
}

// static Future<String?> pickImageAndSave() async {
//   ImagePicker imagePicker = ImagePicker();
//
//   XFile? imgFile = await imagePicker.pickImage(source: ImageSource.gallery);
//   if(imgFile == null) {
//     debugPrint('imgFile == null');
//     return null;
//   }
//
//   Uint8List imgFileBytes = await imgFile.readAsBytes();
//   String imgString = ImageHelper.base64String(imgFileBytes);
//   debugPrint('imgString returned!');
//   return imgString;
// }