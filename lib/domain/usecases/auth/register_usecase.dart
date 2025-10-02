import 'package:flutter_tastyhub/domain/entities/user.dart';
import 'package:flutter_tastyhub/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<User> call(String email, String password, String name) async {
    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      throw Exception('All fields are required');
    }

    if (!_isValidEmail(email)) {
      throw Exception('Please enter a valid email address');
    }

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters long');
    }

    if (name.length < 2) {
      throw Exception('Name must be at least 2 characters long');
    }

    return await repository.registerWithEmailAndPassword(email, password, name);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
