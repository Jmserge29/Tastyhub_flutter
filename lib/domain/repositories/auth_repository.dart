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
}
