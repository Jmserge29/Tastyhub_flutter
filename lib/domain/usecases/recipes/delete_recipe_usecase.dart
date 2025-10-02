import 'package:flutter_tastyhub/domain/entities/receipe.dart';
import 'package:flutter_tastyhub/domain/repositories/recipe_repository.dart';
import 'package:flutter_tastyhub/domain/repositories/storage_repository.dart';

class DeleteRecipeUseCase {
  final RecipeRepository recipeRepository;
  final StorageRepository storageRepository;

  DeleteRecipeUseCase(this.recipeRepository, this.storageRepository);

  Future<void> call(String recipeId, String currentUserId) async {
    if (recipeId.isEmpty) {
      throw Exception('Recipe ID cannot be empty');
    }

    // Obtener la receta para verificar permisos y obtener URL de imagen
    Recipe recipe = await recipeRepository.getRecipeById(recipeId);

    // Verificar que el usuario actual es el propietario
    if (recipe.userId != currentUserId) {
      throw Exception('You can only delete your own recipes');
    }

    // Eliminar imagen si existe
    if (recipe.imageUrl.isNotEmpty) {
      try {
        await storageRepository.deleteImage(recipe.imageUrl);
      } catch (e) {
        // Continuar aunque falle la eliminación de la imagen
      }
    }

    // Eliminar la receta
    await recipeRepository.deleteRecipe(recipeId);
  }
}
