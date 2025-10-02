import 'dart:io';

abstract class StorageRepository {
  Future<String> uploadRecipeImage(File imageFile, String recipeId);
  Future<String> uploadUserProfileImage(File imageFile, String userId);
  Future<void> deleteImage(String imageUrl);
  Future<String> getImageDownloadUrl(String imagePath);
}
