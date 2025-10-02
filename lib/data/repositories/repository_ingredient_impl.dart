import 'package:flutter_tastyhub/data/models/ingredient_model.dart';
import 'package:flutter_tastyhub/shared/errors/failures.dart';
import 'package:flutter_tastyhub/domain/entities/ingredient.dart';
import 'package:flutter_tastyhub/domain/repositories/ingredient_repository.dart';
import 'package:flutter_tastyhub/data/datasources/remote/firebase_ingredient_datasource.dart';

class IngredientRepositoryImpl implements IngredientRepository {
  final FirebaseIngredientDataSource dataSource;

  IngredientRepositoryImpl({required this.dataSource});

  @override
  Future<List<Ingredient>> getAllIngredients() async {
    try {
      final ingredientModels = await dataSource.getAllIngredients();
      return ingredientModels.map((model) => model.toEntity()).toList();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('Failed to get ingredients: ${e.toString()}');
    }
  }

  @override
  Future<Ingredient> getIngredientById(String id) async {
    try {
      final ingredientModel = await dataSource.getIngredientById(id);
      return ingredientModel.toEntity();
    } on NotFoundException catch (e) {
      throw NotFoundFailure(e.message);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('Failed to get ingredient: ${e.toString()}');
    }
  }

  @override
  Future<String> createIngredient(Ingredient ingredient) async {
    try {
      final ingredientModel = IngredientModel.fromEntity(ingredient);
      return await dataSource.createIngredient(ingredientModel);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('Failed to create ingredient: ${e.toString()}');
    }
  }

  @override
  Future<void> updateIngredient(Ingredient ingredient) async {
    try {
      final ingredientModel = IngredientModel.fromEntity(ingredient);
      await dataSource.updateIngredient(ingredientModel);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('Failed to update ingredient: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteIngredient(String id) async {
    try {
      await dataSource.deleteIngredient(id);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('Failed to delete ingredient: ${e.toString()}');
    }
  }

  @override
  Future<List<Ingredient>> searchIngredients(String query) async {
    try {
      final ingredientModels = await dataSource.searchIngredients(query);
      return ingredientModels.map((model) => model.toEntity()).toList();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('Failed to search ingredients: ${e.toString()}');
    }
  }

  @override
  Stream<List<Ingredient>> watchIngredients() {
    try {
      return dataSource.watchIngredients().map(
        (ingredientModels) =>
            ingredientModels.map((model) => model.toEntity()).toList(),
      );
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('Failed to watch ingredients: ${e.toString()}');
    }
  }
}
