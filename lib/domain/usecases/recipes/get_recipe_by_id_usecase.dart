import 'package:flutter_tastyhub/domain/entities/receipe.dart';
import 'package:flutter_tastyhub/domain/repositories/recipe_repository.dart';

class GetRecipeByIdUseCase {
  final RecipeRepository repository;

  GetRecipeByIdUseCase(this.repository);

  Future<Recipe> call(String recipeId) async {
    if (recipeId.isEmpty) {
      throw Exception('Recipe ID cannot be empty');
    }

    return await repository.getRecipeById(recipeId);
  }
}
