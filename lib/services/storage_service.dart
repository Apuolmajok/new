import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = const Uuid();

  // Upload a file
  Future<String?> uploadFile(File file, String path) async {
    try {
      // Generate a unique file name
      String fileName = _uuid.v4();
      // Reference to the storage bucket
      Reference storageRef = _storage.ref().child('$path/$fileName');
      // Upload the file
      UploadTask uploadTask = storageRef.putFile(file);
      // Wait for the upload to complete
      TaskSnapshot snapshot = await uploadTask;
      // Get the download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Download a file
  Future<File?> downloadFile(String url, String savePath) async {
    try {
      // Create a reference to the file
      Reference storageRef = _storage.refFromURL(url);
      // Download the file
      File file = File(savePath);
      await storageRef.writeToFile(file);
      return file;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Delete a file
  Future<void> deleteFile(String url) async {
    try {
      // Create a reference to the file
      Reference storageRef = _storage.refFromURL(url);
      // Delete the file
      await storageRef.delete();
    } catch (e) {
      print(e.toString());
    }
  }

  // List all files in a folder
  Future<List<String>> listFiles(String path) async {
    try {
      // Reference to the folder
      Reference storageRef = _storage.ref().child(path);
      // List all files in the folder
      ListResult result = await storageRef.listAll();
      // Extract the download URLs
      List<String> files = [];
      for (Reference ref in result.items) {
        String downloadUrl = await ref.getDownloadURL();
        files.add(downloadUrl);
      }
      return files;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  // Get the download URL of a file
  Future<String?> getDownloadUrl(String path) async {
    try {
      // Reference to the file
      Reference storageRef = _storage.ref().child(path);
      // Get the download URL
      String downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
