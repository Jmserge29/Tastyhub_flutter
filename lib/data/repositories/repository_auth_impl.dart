import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tastyhub/domain/entities/user.dart';
import 'package:flutter_tastyhub/data/models/user_model.dart';
import 'package:flutter_tastyhub/shared/errors/failures.dart';
import 'package:flutter_tastyhub/data/datasources/remote/firebase_auth_datasource.dart';
import 'package:flutter_tastyhub/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource dataSource;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthRepositoryImpl({required this.dataSource});

  @override
  Future<User?> getCurrentUser() async {
    try {
      final firebaseUser = await dataSource.getCurrentUser();
      if (firebaseUser == null) return null;

      // Obtener datos adicionales de Firestore
      final userDoc = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (userDoc.exists) {
        return UserModel.fromFirestore(userDoc).toEntity();
      }

      // Si no existe en Firestore, crear el documento con valores por defecto
      final userModel = UserModel.fromFirebaseUser(firebaseUser);
      await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .set(userModel.toFirestore());

      return userModel.toEntity();
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('Failed to get current user: ${e.toString()}');
    }
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try {
      final firebaseUser = await dataSource.signInWithEmailAndPassword(
        email,
        password,
      );

      // Obtener datos adicionales de Firestore
      final userDoc = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (userDoc.exists) {
        return UserModel.fromFirestore(userDoc).toEntity();
      }

      // Si no existe en Firestore, crear el documento
      final userModel = UserModel.fromFirebaseUser(firebaseUser);
      await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .set(userModel.toFirestore());

      return userModel.toEntity();
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw AuthFailure('Sign in failed: ${e.toString()}');
    }
  }

  @override
  Future<User> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      final firebaseUser = await dataSource.registerWithEmailAndPassword(
        email,
        password,
        name,
      );

      // Crear el documento del usuario en Firestore con todos los campos
      final userModel = UserModel(
        id: firebaseUser.uid,
        name: name,
        email: email,
        profileImageUrl: firebaseUser.photoURL,
        createdAt: DateTime.now(),
        isActive: true,
        followers: [],
        following: [],
        bio: null,
        role: 'Usuario', // Rol por defecto
      );

      await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .set(userModel.toFirestore());

      return userModel.toEntity();
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw AuthFailure('Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await dataSource.signOut();
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    } catch (e) {
      throw AuthFailure('Sign out failed: ${e.toString()}');
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await dataSource.resetPassword(email);
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    } catch (e) {
      throw AuthFailure('Password reset failed: ${e.toString()}');
    }
  }

  @override
  Stream<User?> authStateChanges() {
    try {
      return dataSource.authStateChanges().asyncMap((firebaseUser) async {
        if (firebaseUser == null) return null;

        // Obtener datos completos de Firestore
        final userDoc = await _firestore
            .collection('users')
            .doc(firebaseUser.uid)
            .get();

        if (userDoc.exists) {
          return UserModel.fromFirestore(userDoc).toEntity();
        }

        // Si no existe, crear el documento
        final userModel = UserModel.fromFirebaseUser(firebaseUser);
        await _firestore
            .collection('users')
            .doc(firebaseUser.uid)
            .set(userModel.toFirestore());

        return userModel.toEntity();
      });
    } catch (e) {
      throw ServerFailure('Failed to watch auth state: ${e.toString()}');
    }
  }

  // ========== MÉTODOS DE GESTIÓN DE USUARIOS ==========

  @override
  Future<User?> getUserById(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();

      if (!doc.exists) {
        return null;
      }

      return UserModel.fromFirestore(doc).toEntity();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('Error al obtener usuario: ${e.toString()}');
    }
  }

  @override
  Future<void> followUser(String currentUserId, String userToFollowId) async {
    try {
      final batch = _firestore.batch();

      // Agregar a la lista de following del usuario actual
      final currentUserRef = _firestore.collection('users').doc(currentUserId);
      batch.update(currentUserRef, {
        'following': FieldValue.arrayUnion([userToFollowId]),
      });

      // Agregar a la lista de followers del usuario a seguir
      final targetUserRef = _firestore.collection('users').doc(userToFollowId);
      batch.update(targetUserRef, {
        'followers': FieldValue.arrayUnion([currentUserId]),
      });

      await batch.commit();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('Error al seguir usuario: ${e.toString()}');
    }
  }

  @override
  Future<void> unfollowUser(
    String currentUserId,
    String userToUnfollowId,
  ) async {
    try {
      final batch = _firestore.batch();

      // Eliminar de la lista de following del usuario actual
      final currentUserRef = _firestore.collection('users').doc(currentUserId);
      batch.update(currentUserRef, {
        'following': FieldValue.arrayRemove([userToUnfollowId]),
      });

      // Eliminar de la lista de followers del usuario a dejar de seguir
      final targetUserRef = _firestore
          .collection('users')
          .doc(userToUnfollowId);
      batch.update(targetUserRef, {
        'followers': FieldValue.arrayRemove([currentUserId]),
      });

      await batch.commit();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('Error al dejar de seguir usuario: ${e.toString()}');
    }
  }

  @override
  Future<List<User>> getFollowers(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        return [];
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final followerIds = List<String>.from(userData['followers'] ?? []);

      if (followerIds.isEmpty) {
        return [];
      }

      final followers = <User>[];
      for (final followerId in followerIds) {
        final followerDoc = await _firestore
            .collection('users')
            .doc(followerId)
            .get();
        if (followerDoc.exists) {
          followers.add(UserModel.fromFirestore(followerDoc).toEntity());
        }
      }

      return followers;
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('Error al obtener seguidores: ${e.toString()}');
    }
  }

  @override
  Future<List<User>> getFollowing(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        return [];
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final followingIds = List<String>.from(userData['following'] ?? []);

      if (followingIds.isEmpty) {
        return [];
      }

      final following = <User>[];
      for (final followingId in followingIds) {
        final followingDoc = await _firestore
            .collection('users')
            .doc(followingId)
            .get();
        if (followingDoc.exists) {
          following.add(UserModel.fromFirestore(followingDoc).toEntity());
        }
      }

      return following;
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(
        'Error al obtener usuarios seguidos: ${e.toString()}',
      );
    }
  }

  @override
  Future<bool> isFollowing(String currentUserId, String targetUserId) async {
    try {
      final doc = await _firestore.collection('users').doc(currentUserId).get();

      if (!doc.exists) {
        return false;
      }

      final userData = doc.data() as Map<String, dynamic>;
      final following = List<String>.from(userData['following'] ?? []);

      return following.contains(targetUserId);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('Error al verificar seguimiento: ${e.toString()}');
    }
  }

  @override
  Future<void> updateUserProfile({
    required String userId,
    String? name,
    String? bio,
    String? role,
    String? profileImageUrl,
  }) async {
    try {
      final updates = <String, dynamic>{};

      if (name != null) updates['name'] = name;
      if (bio != null) updates['bio'] = bio;
      if (role != null) updates['role'] = role;
      if (profileImageUrl != null) updates['profileImageUrl'] = profileImageUrl;

      if (updates.isNotEmpty) {
        await _firestore.collection('users').doc(userId).update(updates);
      }
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('Error al actualizar perfil: ${e.toString()}');
    }
  }

  @override
  Stream<User?> watchUser(String userId) {
    try {
      return _firestore.collection('users').doc(userId).snapshots().map((doc) {
        if (!doc.exists) {
          return null;
        }
        return UserModel.fromFirestore(doc).toEntity();
      });
    } catch (e) {
      throw ServerFailure('Error al observar usuario: ${e.toString()}');
    }
  }
}
