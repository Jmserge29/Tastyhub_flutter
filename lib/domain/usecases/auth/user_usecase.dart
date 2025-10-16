// ========== FOLLOW USER USE CASE ==========
import 'package:flutter_tastyhub/domain/entities/user.dart';
import 'package:flutter_tastyhub/domain/repositories/auth_repository.dart';

class FollowUserUseCase {
  final AuthRepository repository;

  FollowUserUseCase(this.repository);

  Future<void> call(String currentUserId, String userToFollowId) async {
    return await repository.followUser(currentUserId, userToFollowId);
  }
}

// ========== UNFOLLOW USER USE CASE ==========
class UnfollowUserUseCase {
  final AuthRepository repository;

  UnfollowUserUseCase(this.repository);

  Future<void> call(String currentUserId, String userToUnfollowId) async {
    return await repository.unfollowUser(currentUserId, userToUnfollowId);
  }
}

// ========== GET USER BY ID USE CASE ==========
class GetUserByIdUseCase {
  final AuthRepository repository;

  GetUserByIdUseCase(this.repository);

  Future<User?> call(String userId) async {
    return await repository.getUserById(userId);
  }
}

// ========== GET FOLLOWERS USE CASE ==========
class GetFollowersUseCase {
  final AuthRepository repository;

  GetFollowersUseCase(this.repository);

  Future<List<User>> call(String userId) async {
    return await repository.getFollowers(userId);
  }
}

// ========== GET FOLLOWING USE CASE ==========
class GetFollowingUseCase {
  final AuthRepository repository;

  GetFollowingUseCase(this.repository);

  Future<List<User>> call(String userId) async {
    return await repository.getFollowing(userId);
  }
}

// ========== IS FOLLOWING USE CASE ==========
class IsFollowingUseCase {
  final AuthRepository repository;

  IsFollowingUseCase(this.repository);

  Future<bool> call(String currentUserId, String targetUserId) async {
    return await repository.isFollowing(currentUserId, targetUserId);
  }
}

// ========== UPDATE USER PROFILE USE CASE ==========
class UpdateUserProfileUseCase {
  final AuthRepository repository;

  UpdateUserProfileUseCase(this.repository);

  Future<void> call({
    required String userId,
    String? name,
    String? bio,
    String? role,
    String? profileImageUrl,
  }) async {
    return await repository.updateUserProfile(
      userId: userId,
      name: name,
      bio: bio,
      role: role,
      profileImageUrl: profileImageUrl,
    );
  }
}
