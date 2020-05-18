import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_chatting_app/constants/string.dart';

class UpdateMethods {
  StorageReference _storageReference;
  final Firestore _firestore = Firestore.instance;

  Future<void> updatePhoto(String photoUrl, String uid) async {
//    Map<String, dynamic> map = Map();
//    map['profile_photo'] = photoUrl;
    return _firestore
        .collection(user_collection)
        .document(uid)
        .updateData({'profile_photo': photoUrl});
  }

  Future<String> uploadImageToStorage(File imageFile) async {
    _storageReference = FirebaseStorage.instance
        .ref()
        .child('${DateTime.now().millisecondsSinceEpoch}');
    StorageUploadTask storageUploadTask = _storageReference.putFile(imageFile);
    var url = await (await storageUploadTask.onComplete).ref.getDownloadURL();
    return url;
  }
}
