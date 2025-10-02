import 'dart:io';

import 'package:flutter_tastyhub/domain/entities/receipe.dart';
import 'package:flutter_tastyhub/domain/repositories/recipe_repository.dart';
import 'package:flutter_tastyhub/domain/repositories/storage_repository.dart';

class UpdateRecipeUseCase {
  final RecipeRepository recipeRepository;
  final StorageRepository storageRepository;

  UpdateRecipeUseCase(this.recipeRepository, this.storageRepository);

  Future<void> call({required Recipe recipe, File? newImageFile}) async {
    // Validaciones
    if (recipe.title.isEmpty) {
      throw Exception('Recipe title cannot be empty');
    }
    if (recipe.description.isEmpty) {
      throw Exception('Recipe description cannot be empty');
    }
    if (recipe.ingredients.isEmpty) {
      throw Exception('Recipe must have at least one ingredient');
    }

    Recipe updatedRecipe = recipe;

    // Si hay una nueva imagen, subirla
    if (newImageFile != null) {
      // Eliminar imagen anterior si existe
      if (recipe.imageUrl.isNotEmpty) {
        try {
          await storageRepository.deleteImage(recipe.imageUrl);
        } catch (e) {
          // Continuar aunque falle la eliminación
        }
      }

      // Subir nueva imagen
      String newImageUrl = await storageRepository.uploadRecipeImage(
        newImageFile,
        recipe.id,
      );
      updatedRecipe = Recipe(
        id: recipe.id,
        title: recipe.title,
        description: recipe.description,
        ingredients: recipe.ingredients,
        imageUrl: newImageUrl,
        prepTime: recipe.prepTime,
        categoryId: recipe.categoryId,
        userId: recipe.userId,
        createdAt: recipe.createdAt,
      );
    }

    await recipeRepository.updateRecipe(updatedRecipe);
  }
}
