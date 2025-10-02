import 'dart:io';

import 'package:flutter_tastyhub/domain/repositories/storage_repository.dart';

class UploadProfileImageUseCase {
  final StorageRepository repository;

  UploadProfileImageUseCase(this.repository);

  Future<String> call(File imageFile, String userId) async {
    if (!imageFile.existsSync()) {
      throw Exception('Image file does not exist');
    }

    if (userId.isEmpty) {
      throw Exception('User ID cannot be empty');
    }

    String extension = imageFile.path.split('.').last.toLowerCase();
    if (!['jpg', 'jpeg', 'png', 'webp'].contains(extension)) {
      throw Exception('Unsupported image format. Please use JPG, PNG, or WebP');
    }

    int fileSizeInBytes = await imageFile.length();
    if (fileSizeInBytes > 2 * 1024 * 1024) {
      throw Exception('Profile image size must be less than 2MB');
    }

    return await repository.uploadUserProfileImage(imageFile, userId);
  }
}