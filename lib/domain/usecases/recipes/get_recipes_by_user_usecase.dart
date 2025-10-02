import 'package:flutter_tastyhub/domain/entities/receipe.dart';
import 'package:flutter_tastyhub/domain/repositories/recipe_repository.dart';

class GetRecipesByUserUseCase {
  final RecipeRepository repository;

  GetRecipesByUserUseCase(this.repository);

  Future<List<Recipe>> call(String userId) async {
    if (userId.isEmpty) {
      throw Exception('User ID cannot be empty');
    }
    return await repository.getRecipesByUser(userId);
  }
}
