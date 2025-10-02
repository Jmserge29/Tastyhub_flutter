import 'package:flutter_tastyhub/domain/entities/user.dart';
import 'package:flutter_tastyhub/domain/repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<User?> call() async {
    return await repository.getCurrentUser();
  }
}
