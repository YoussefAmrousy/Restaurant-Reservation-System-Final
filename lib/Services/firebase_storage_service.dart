import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String?> uploadImage({
    required File imageToUpload,
    required String title,
    required String type,
  }) async {
    try {
      final Reference firebaseStorageRef = _firebaseStorage
          .ref()
          .child(type == "logo" ? 'logos': "menus")
          .child('${title.toLowerCase()}.png');

      await firebaseStorageRef.putFile(imageToUpload);
      return await firebaseStorageRef.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> getImageUrl(String title) async {
    try {
      final Reference firebaseStorageRef = _firebaseStorage
          .ref()
          .child('logos')
          .child('${title.toLowerCase()}.png');
      final String imgUrl = await firebaseStorageRef.getDownloadURL();
      return imgUrl;
    } catch (e) {
      rethrow;
    }
  }
}
