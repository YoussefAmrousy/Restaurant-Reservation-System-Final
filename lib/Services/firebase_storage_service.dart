import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<void> uploadImage({
    required File imageToUpload,
    required String title,
  }) async {
    try {
      final Reference firebaseStorageRef = _firebaseStorage
          .ref()
          .child('logos')
          .child('${title.toLowerCase()}.png');
      firebaseStorageRef.putFile(imageToUpload);
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> getImageUrl(String title) async {
    try {
      final Reference firebaseStorageRef =
          _firebaseStorage.ref().child('logos').child(title.toLowerCase());
      final String imgUrl = await firebaseStorageRef.getDownloadURL();
      return imgUrl;
    } catch (e) {
      rethrow;
    }
  }
}
