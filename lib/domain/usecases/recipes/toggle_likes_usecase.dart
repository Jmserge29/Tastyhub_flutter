import 'package:flutter_tastyhub/domain/entities/receipe.dart';
import 'package:flutter_tastyhub/domain/repositories/recipe_repository.dart';

class ToggleLikeUseCase {
  final RecipeRepository repository;

  ToggleLikeUseCase(this.repository);

  Future<void> call(String recipeId, String userId) async {
    if (recipeId.isEmpty) {
      throw Exception('Recipe ID cannot be empty');
    }
    if (userId.isEmpty) {
      throw Exception('User ID cannot be empty');
    }

    await repository.toggleLike(recipeId, userId);
  }
}

class GetLikedRecipesByUserUseCase {
  final RecipeRepository repository;

  GetLikedRecipesByUserUseCase(this.repository);

  Future<List<Recipe>> call(String userId) async {
    if (userId.isEmpty) {
      throw Exception('User ID cannot be empty');
    }

    return await repository.getLikedRecipesByUser(userId);
  }
}
