import 'dart:io';

import 'package:flutter_tastyhub/data/datasources/remote/firebase_storage_datasource.dart';
import 'package:flutter_tastyhub/domain/repositories/storage_repository.dart';
import 'package:flutter_tastyhub/shared/errors/failures.dart';

class StorageRepositoryImpl implements StorageRepository {
  final FirebaseStorageDataSource dataSource;

  StorageRepositoryImpl({required this.dataSource});

  @override
  Future<String> uploadRecipeImage(File imageFile, String recipeId) async {
    try {
      return await dataSource.uploadRecipeImage(imageFile, recipeId);
    } on StorageException catch (e) {
      throw StorageFailure(e.message);
    } catch (e) {
      throw StorageFailure('Failed to upload recipe image: ${e.toString()}');
    }
  }

  @override
  Future<String> uploadUserProfileImage(File imageFile, String userId) async {
    try {
      return await dataSource.uploadUserProfileImage(imageFile, userId);
    } on StorageException catch (e) {
      throw StorageFailure(e.message);
    } catch (e) {
      throw StorageFailure('Failed to upload profile image: ${e.toString()}');
    }
  }

  @override
  Future<String> uploadCategoryImage(File imageFile, String categoryId) async {
    try {
      return await dataSource.uploadCategoryImage(imageFile, categoryId);
    } on StorageException catch (e) {
      throw StorageFailure(e.message);
    } catch (e) {
      throw StorageFailure('Failed to upload category image: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteImage(String imageUrl) async {
    try {
      await dataSource.deleteImage(imageUrl);
    } on StorageException catch (e) {
      throw StorageFailure(e.message);
    } catch (e) {
      throw StorageFailure('Failed to delete image: ${e.toString()}');
    }
  }

  @override
  Future<String> getImageDownloadUrl(String imagePath) async {
    try {
      return await dataSource.getImageDownloadUrl(imagePath);
    } on StorageException catch (e) {
      throw StorageFailure(e.message);
    } catch (e) {
      throw StorageFailure('Failed to get image URL: ${e.toString()}');
    }
  }

  @override
  Future<List<String>> uploadMultipleImages(
    List<File> imageFiles,
    String folderId,
  ) async {
    try {
      return await dataSource.uploadMultipleImages(imageFiles, folderId);
    } on StorageException catch (e) {
      throw StorageFailure(e.message);
    } catch (e) {
      throw StorageFailure('Failed to upload multiple images: ${e.toString()}');
    }
  }
}
