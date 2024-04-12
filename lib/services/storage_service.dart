import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class StorageService {
  late final FirebaseStorage _storage;

  StorageService() {
    _storage =FirebaseStorage.instanceFor(bucket: dotenv.env['FIREBASE_STORAGE_URL']);
  }

  Future<String> uploadImage(String imagePath) async {
    try {
      final reference = _storage.ref().child('uploads/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final file = File(imagePath);
      final task = reference.putFile(file);
      final snapshot = await task.whenComplete(() => null);
      final url = await snapshot.ref.getDownloadURL();
      return url;
    } on FirebaseException catch(e) {
      print('Firebase Storage Error: ${e.code} - ${e.message}');
      rethrow;
    }
  }
}