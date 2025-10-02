import 'dart:io';
import 'package:flutter_tastyhub/domain/entities/receipe.dart';
import 'package:flutter_tastyhub/domain/repositories/recipe_repository.dart';
import 'package:flutter_tastyhub/domain/repositories/storage_repository.dart';

class CreateRecipeUseCase {
  final RecipeRepository recipeRepository;
  final StorageRepository storageRepository;

  CreateRecipeUseCase(this.recipeRepository, this.storageRepository);

  Future<String> call({
    required String title,
    required String description,
    required List<String> ingredients,
    required int prepTime,
    required String categoryId,
    required String userId,
    File? imageFile,
  }) async {
    // Validaciones
    if (title.isEmpty) {
      throw Exception('Recipe title cannot be empty');
    }
    if (description.isEmpty) {
      throw Exception('Recipe description cannot be empty');
    }
    if (ingredients.isEmpty) {
      throw Exception('Recipe must have at least one ingredient');
    }
    if (prepTime <= 0) {
      throw Exception('Preparation time must be greater than 0');
    }

    // Crear receta temporalmente sin imagen
    Recipe recipe = Recipe(
      id: '', // Se asignará por Firebase
      title: title,
      description: description,
      ingredients: ingredients,
      imageUrl: '',
      prepTime: prepTime,
      categoryId: categoryId,
      userId: userId,
      createdAt: DateTime.now(),
    );

    // Crear la receta primero para obtener el ID
    String recipeId = await recipeRepository.createRecipe(recipe);

    // Si hay imagen, subirla y actualizar la receta
    if (imageFile != null) {
      String imageUrl = await storageRepository.uploadRecipeImage(
        imageFile,
        recipeId,
      );

      Recipe updatedRecipe = Recipe(
        id: recipeId,
        title: title,
        description: description,
        ingredients: ingredients,
        imageUrl: imageUrl,
        prepTime: prepTime,
        categoryId: categoryId,
        userId: userId,
        createdAt: recipe.createdAt,
      );

      await recipeRepository.updateRecipe(updatedRecipe);
    }

    return recipeId;
  }
}
