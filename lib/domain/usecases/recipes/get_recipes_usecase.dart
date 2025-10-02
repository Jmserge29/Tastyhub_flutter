import 'package:flutter_tastyhub/domain/entities/receipe.dart';
import 'package:flutter_tastyhub/domain/repositories/recipe_repository.dart';

class GetRecipesUseCase {
  final RecipeRepository repository;

  GetRecipesUseCase(this.repository);

  Future<List<Recipe>> call() async {
    return await repository.getAllRecipes();
  }
}
