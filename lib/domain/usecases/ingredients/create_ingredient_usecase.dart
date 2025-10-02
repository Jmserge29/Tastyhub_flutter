import 'package:flutter_tastyhub/domain/entities/ingredient.dart';
import 'package:flutter_tastyhub/domain/repositories/ingredient_repository.dart';

class CreateIngredientUseCase {
  final IngredientRepository repository;

  CreateIngredientUseCase(this.repository);

  Future<String> call(String name) async {
    if (name.isEmpty) {
      throw Exception('Ingredient name cannot be empty');
    }

    // Normalizar el nombre (primera letra mayúscula, resto minúsculas)
    String normalizedName = name.trim().toLowerCase();
    normalizedName =
        normalizedName[0].toUpperCase() + normalizedName.substring(1);

    Ingredient ingredient = Ingredient(id: '', name: normalizedName);

    return await repository.createIngredient(ingredient);
  }
}
