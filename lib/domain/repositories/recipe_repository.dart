import 'package:flutter_tastyhub/domain/entities/receipe.dart';

abstract class RecipeRepository {
  Future<List<Recipe>> getAllRecipes();
  Future<List<Recipe>> getRecipesByCategory(String categoryId);
  Future<List<Recipe>> getRecipesByUser(String userId);
  Future<Recipe> getRecipeById(String id);
  Future<String> createRecipe(Recipe recipe);
  Future<void> updateRecipe(Recipe recipe);
  Future<void> deleteRecipe(String id);
  Future<List<Recipe>> searchRecipes(String query);
  Stream<List<Recipe>> watchRecipes();
  Future<void> toggleLike(String recipeId, String userId);
  Future<List<Recipe>> getLikedRecipesByUser(String userId);
}
