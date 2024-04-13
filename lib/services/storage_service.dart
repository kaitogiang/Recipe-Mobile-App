import 'dart:io';

import 'package:ct484_project/models/auth_token.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class StorageService {
  late final FirebaseStorage _storage;
  String? _token;
  String? _userId;

  StorageService([AuthToken? authToken]) 
  : _token = authToken?.token,
    _userId = authToken?.userId
  {
    _storage =FirebaseStorage.instanceFor(bucket: dotenv.env['FIREBASE_STORAGE_URL']);
  }

  set authToken(AuthToken? authToken) {
    _token = authToken?.token;
    _userId = authToken?.userId;
  }

  @protected
  String? get token => _token;

  @protected
  String? get userId => _userId;

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

  Future<String> getImageNameFromUrl(String downloadedUrl) async {
    try {
      final httpReference = _storage.refFromURL(downloadedUrl);
      return httpReference.name;
    } on FirebaseException catch(e) {
      print('Firebase storage Error: ${e.code} - ${e.message}');
      rethrow;
    }
  }

  Future<void> removeUploadedFile(String imageName) async {
    final reference = _storage.ref().child('uploads/$imageName');
    try {
      await reference.delete();
    } on FirebaseException catch (e) {
      print('Error deleting image: ${e.code} - ${e.message}');
    }
  }
}