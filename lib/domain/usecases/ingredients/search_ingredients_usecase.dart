import 'package:flutter_tastyhub/domain/entities/ingredient.dart';
import 'package:flutter_tastyhub/domain/repositories/ingredient_repository.dart';

class SearchIngredientsUseCase {
  final IngredientRepository repository;

  SearchIngredientsUseCase(this.repository);

  Future<List<Ingredient>> call(String query) async {
    if (query.isEmpty) {
      return [];
    }
    return await repository.searchIngredients(query);
  }
}
