import 'package:flutter_tastyhub/domain/entities/receipe.dart';
import 'package:flutter_tastyhub/domain/repositories/recipe_repository.dart';

class SearchRecipesUseCase {
  final RecipeRepository repository;

  SearchRecipesUseCase(this.repository);

  Future<List<Recipe>> call(String query) async {
    if (query.isEmpty) {
      return [];
    }
    return await repository.searchRecipes(query);
  }
}
