import 'package:flutter_tastyhub/domain/repositories/storage_repository.dart';

class DeleteImageUseCase {
  final StorageRepository repository;

  DeleteImageUseCase(this.repository);

  Future<void> call(String imageUrl) async {
    if (imageUrl.isEmpty) {
      throw Exception('Image URL cannot be empty');
    }

    return await repository.deleteImage(imageUrl);
  }
}
