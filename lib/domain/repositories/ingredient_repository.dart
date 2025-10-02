import 'package:flutter_tastyhub/domain/entities/ingredient.dart';

abstract class IngredientRepository {
  Future<List<Ingredient>> getAllIngredients();
  Future<Ingredient> getIngredientById(String id);
  Future<String> createIngredient(Ingredient ingredient);
  Future<void> updateIngredient(Ingredient ingredient);
  Future<void> deleteIngredient(String id);
  Future<List<Ingredient>> searchIngredients(String query);
  Stream<List<Ingredient>> watchIngredients();
}
