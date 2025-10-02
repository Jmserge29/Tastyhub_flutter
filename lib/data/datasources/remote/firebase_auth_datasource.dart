import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tastyhub/shared/errors/failures.dart';

abstract class FirebaseAuthDataSource {
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

class FirebaseAuthDataSourceImpl implements FirebaseAuthDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  FirebaseAuthDataSourceImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<User?> getCurrentUser() async {
    try {
      return _firebaseAuth.currentUser;
    } catch (e) {
      throw AuthException('Failed to get current user: ${e.toString()}');
    }
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw AuthException('Authentication failed');
      }

      return credential.user!;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getAuthErrorMessage(e.code));
    } catch (e) {
      throw AuthException('Sign in failed: ${e.toString()}');
    }
  }

  @override
  Future<User> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw AuthException('Registration failed');
      }

      // Actualizar el perfil del usuario con el nombre
      await credential.user!.updateDisplayName(name);

      // Crear documento del usuario en Firestore
      await _createUserDocument(credential.user!, name);

      return credential.user!;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getAuthErrorMessage(e.code));
    } catch (e) {
      throw AuthException('Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw AuthException('Sign out failed: ${e.toString()}');
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getAuthErrorMessage(e.code));
    } catch (e) {
      throw AuthException('Password reset failed: ${e.toString()}');
    }
  }

  @override
  Stream<User?> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }

  Future<void> _createUserDocument(User user, String name) async {
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'name': name,
        'email': user.email,
        'profileImageUrl': null,
        'createdAt': FieldValue.serverTimestamp(),
        'isActive': true,
      });
    } catch (e) {
      throw ServerException('Failed to create user document: ${e.toString()}');
    }
  }

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email address';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'An account already exists with this email address';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'This user account has been disabled';
      case 'too-many-requests':
        return 'Too many requests. Please try again later';
      default:
        return 'Authentication error occurred';
    }
  }
}
