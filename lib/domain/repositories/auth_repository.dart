import 'package:flutter_tastyhub/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User?> getCurrentUser();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
  );
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Stream<User?> authStateChanges();
  Future<User?> getUserById(String userId);
  Future<void> followUser(String currentUserId, String userToFollowId);
  Future<void> unfollowUser(String currentUserId, String userToUnfollowId);
  Future<List<User>> getFollowers(String userId);
  Future<List<User>> getFollowing(String userId);
  Future<bool> isFollowing(String currentUserId, String targetUserId);
  Future<void> updateUserProfile({
    required String userId,
    String? name,
    String? bio,
    String? role,
    String? profileImageUrl,
  });
  Stream<User?> watchUser(String userId);
}
