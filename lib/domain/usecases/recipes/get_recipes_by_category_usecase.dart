import 'package:flutter_tastyhub/domain/entities/receipe.dart';
import 'package:flutter_tastyhub/domain/repositories/recipe_repository.dart';

class GetRecipesByCategoryUseCase {
  final RecipeRepository repository;

  GetRecipesByCategoryUseCase(this.repository);

  Future<List<Recipe>> call(String categoryId) async {
    if (categoryId.isEmpty) {
      throw Exception('Category ID cannot be empty');
    }
    return await repository.getRecipesByCategory(categoryId);
  }
}
