import 'package:flutter_tastyhub/data/models/recipe_model.dart';
import 'package:flutter_tastyhub/shared/errors/failures.dart';
import 'package:flutter_tastyhub/domain/entities/receipe.dart';
import 'package:flutter_tastyhub/domain/repositories/recipe_repository.dart';
import 'package:flutter_tastyhub/data/datasources/remote/firebase_recipe_datasource.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final FirebaseRecipeDataSource dataSource;

  RecipeRepositoryImpl({required this.dataSource});

  @override
  Future<List<Recipe>> getAllRecipes() async {
    try {
      final recipeModels = await dataSource.getAllRecipes();
      return recipeModels.map((model) => model.toEntity()).toList();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('Failed to get recipes: ${e.toString()}');
    }
  }

  @override
  Future<List<Recipe>> getRecipesByCategory(String categoryId) async {
    try {
      final recipeModels = await dataSource.getRecipesByCategory(categoryId);
      return recipeModels.map((model) => model.toEntity()).toList();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('Failed to get recipes by category: ${e.toString()}');
    }
  }

  @override
  Future<void> toggleLike(String recipeId, String userId) async {
    try {
      await dataSource.toggleLike(recipeId, userId);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<List<Recipe>> getLikedRecipesByUser(String userId) async {
    try {
      final recipeModels = await dataSource.getLikedRecipesByUser(userId);
      return recipeModels.map((model) => model.toEntity()).toList();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<List<Recipe>> getRecipesByUser(String userId) async {
    try {
      final recipeModels = await dataSource.getRecipesByUser(userId);
      return recipeModels.map((model) => model.toEntity()).toList();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('Failed to get recipes by user: ${e.toString()}');
    }
  }

  @override
  Future<Recipe> getRecipeById(String id) async {
    try {
      final recipeModel = await dataSource.getRecipeById(id);
      return recipeModel.toEntity();
    } on NotFoundException catch (e) {
      throw NotFoundFailure(e.message);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('Failed to get recipe: ${e.toString()}');
    }
  }

  @override
  Future<String> createRecipe(Recipe recipe) async {
    try {
      final recipeModel = RecipeModel.fromEntity(recipe);
      return await dataSource.createRecipe(recipeModel);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('Failed to create recipe: ${e.toString()}');
    }
  }

  @override
  Future<void> updateRecipe(Recipe recipe) async {
    try {
      final recipeModel = RecipeModel.fromEntity(recipe);
      await dataSource.updateRecipe(recipeModel);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('Failed to update recipe: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteRecipe(String id) async {
    try {
      await dataSource.deleteRecipe(id);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('Failed to delete recipe: ${e.toString()}');
    }
  }

  @override
  Future<List<Recipe>> searchRecipes(String query) async {
    try {
      final recipeModels = await dataSource.searchRecipes(query);
      return recipeModels.map((model) => model.toEntity()).toList();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('Failed to search recipes: ${e.toString()}');
    }
  }

  @override
  Stream<List<Recipe>> watchRecipes() {
    try {
      return dataSource.watchRecipes().map(
        (recipeModels) =>
            recipeModels.map((model) => model.toEntity()).toList(),
      );
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('Failed to watch recipes: ${e.toString()}');
    }
  }
}
