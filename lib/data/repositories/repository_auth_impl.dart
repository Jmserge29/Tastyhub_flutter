import 'package:flutter_tastyhub/domain/entities/user.dart';
import 'package:flutter_tastyhub/data/models/user_model.dart';
import 'package:flutter_tastyhub/shared/errors/failures.dart';
import 'package:flutter_tastyhub/data/datasources/remote/firebase_auth_datasource.dart';
import 'package:flutter_tastyhub/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource dataSource;

  AuthRepositoryImpl({required this.dataSource});

  @override
  Future<User?> getCurrentUser() async {
    try {
      final firebaseUser = await dataSource.getCurrentUser();
      if (firebaseUser == null) return null;

      final userModel = UserModel.fromFirebaseUser(firebaseUser);
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
      final userModel = UserModel.fromFirebaseUser(firebaseUser);
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
      final userModel = UserModel.fromFirebaseUser(firebaseUser);
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
      return dataSource.authStateChanges().map((firebaseUser) {
        if (firebaseUser == null) return null;
        final userModel = UserModel.fromFirebaseUser(firebaseUser);
        return userModel.toEntity();
      });
    } catch (e) {
      throw ServerFailure('Failed to watch auth state: ${e.toString()}');
    }
  }
}
