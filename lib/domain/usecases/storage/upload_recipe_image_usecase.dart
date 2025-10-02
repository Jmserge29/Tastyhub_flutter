import 'dart:io';
import 'package:flutter_tastyhub/domain/repositories/storage_repository.dart';

class UploadRecipeImageUseCase {
  final StorageRepository repository;

  UploadRecipeImageUseCase(this.repository);

  Future<String> call(File imageFile, String recipeId) async {
    if (!imageFile.existsSync()) {
      throw Exception('Image file does not exist');
    }

    if (recipeId.isEmpty) {
      throw Exception('Recipe ID cannot be empty');
    }

    // Validar tipo de archivo (opcional)
    String extension = imageFile.path.split('.').last.toLowerCase();
    if (!['jpg', 'jpeg', 'png', 'webp'].contains(extension)) {
      throw Exception('Unsupported image format. Please use JPG, PNG, or WebP');
    }

    // Validar tamaño de archivo (opcional - máximo 5MB)
    int fileSizeInBytes = await imageFile.length();
    if (fileSizeInBytes > 5 * 1024 * 1024) {
      throw Exception('Image size must be less than 5MB');
    }

    return await repository.uploadRecipeImage(imageFile, recipeId);
  }
}
