import 'dart:io';

import 'package:flutter_tastyhub/domain/repositories/auth_repository.dart';
import 'package:flutter_tastyhub/domain/repositories/storage_repository.dart';

class UpdateUserProfileUseCase {
  final AuthRepository authRepository;
  final StorageRepository storageRepository;

  UpdateUserProfileUseCase(this.authRepository, this.storageRepository);

  Future<void> call({
    required String userId,
    String? name,
    String? bio,
    String? role,
    File? newProfileImage,
  }) async {
    // Validaciones
    if (name != null && name.isEmpty) {
      throw Exception('Name cannot be empty');
    }

    String? profileImageUrl;

    if (newProfileImage != null) {
      profileImageUrl = await storageRepository.uploadUserProfileImage(
        newProfileImage,
        userId,
      );
    }

    // Actualizar el perfil
    await authRepository.updateUserProfile(
      userId: userId,
      name: name,
      bio: bio,
      role: role,
      profileImageUrl: profileImageUrl,
    );
  }
}
