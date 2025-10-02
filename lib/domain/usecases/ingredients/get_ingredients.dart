import 'package:flutter_tastyhub/domain/entities/ingredient.dart';
import 'package:flutter_tastyhub/domain/repositories/ingredient_repository.dart';

class GetIngredientsUseCase {
  final IngredientRepository repository;

  GetIngredientsUseCase(this.repository);

  Future<List<Ingredient>> call() async {
    return await repository.getAllIngredients();
  }
}
