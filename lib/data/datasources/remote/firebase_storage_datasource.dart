import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_tastyhub/shared/errors/failures.dart';

abstract class FirebaseStorageDataSource {
  Future<String> uploadRecipeImage(File imageFile, String recipeId);
  Future<String> uploadUserProfileImage(File imageFile, String userId);
  Future<String> uploadCategoryImage(File imageFile, String categoryId);
  Future<void> deleteImage(String imageUrl);
  Future<String> getImageDownloadUrl(String imagePath);
  Future<List<String>> uploadMultipleImages(
    List<File> imageFiles,
    String folderId,
  );
}

class FirebaseStorageDataSourceImpl implements FirebaseStorageDataSource {
  final FirebaseStorage _storage;

  FirebaseStorageDataSourceImpl({FirebaseStorage? storage})
    : _storage = storage ?? FirebaseStorage.instance;

  @override
  Future<String> uploadRecipeImage(File imageFile, String recipeId) async {
    try {
      final fileName =
          '${recipeId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child('recipes').child(fileName);

      final uploadTask = ref.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'recipeId': recipeId,
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } on FirebaseException catch (e) {
      throw StorageException('Failed to upload recipe image: ${e.message}');
    } catch (e) {
      throw StorageException('Failed to upload recipe image: ${e.toString()}');
    }
  }

  @override
  Future<String> uploadUserProfileImage(File imageFile, String userId) async {
    try {
      final fileName = '${userId}_profile.jpg';
      final ref = _storage.ref().child('profiles').child(fileName);

      final uploadTask = ref.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'userId': userId,
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } on FirebaseException catch (e) {
      throw StorageException('Failed to upload profile image: ${e.message}');
    } catch (e) {
      throw StorageException('Failed to upload profile image: ${e.toString()}');
    }
  }

  @override
  Future<String> uploadCategoryImage(File imageFile, String categoryId) async {
    try {
      final fileName = '${categoryId}_category.jpg';
      final ref = _storage.ref().child('categories').child(fileName);

      final uploadTask = ref.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'categoryId': categoryId,
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } on FirebaseException catch (e) {
      throw StorageException('Failed to upload category image: ${e.message}');
    } catch (e) {
      throw StorageException(
        'Failed to upload category image: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> deleteImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        // La imagen ya no existe, no es un error crítico
        return;
      }
      throw StorageException('Failed to delete image: ${e.message}');
    } catch (e) {
      throw StorageException('Failed to delete image: ${e.toString()}');
    }
  }

  @override
  Future<String> getImageDownloadUrl(String imagePath) async {
    try {
      final ref = _storage.ref().child(imagePath);
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw StorageException('Failed to get download URL: ${e.message}');
    } catch (e) {
      throw StorageException('Failed to get download URL: ${e.toString()}');
    }
  }

  @override
  Future<List<String>> uploadMultipleImages(
    List<File> imageFiles,
    String folderId,
  ) async {
    try {
      final List<String> downloadUrls = [];

      for (int i = 0; i < imageFiles.length; i++) {
        final file = imageFiles[i];
        final fileName =
            '${folderId}_${i}_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final ref = _storage.ref().child('multiple').child(fileName);

        final uploadTask = ref.putFile(
          file,
          SettableMetadata(
            contentType: 'image/jpeg',
            customMetadata: {
              'folderId': folderId,
              'index': i.toString(),
              'uploadedAt': DateTime.now().toIso8601String(),
            },
          ),
        );

        final snapshot = await uploadTask.whenComplete(() {});
        final downloadUrl = await snapshot.ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      }

      return downloadUrls;
    } on FirebaseException catch (e) {
      throw StorageException('Failed to upload multiple images: ${e.message}');
    } catch (e) {
      throw StorageException(
        'Failed to upload multiple images: ${e.toString()}',
      );
    }
  }
}
