import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tastyhub/shared/errors/failures.dart';
import 'package:flutter_tastyhub/data/models/recipe_model.dart';

abstract class FirebaseRecipeDataSource {
  Future<List<RecipeModel>> getAllRecipes();
  Future<List<RecipeModel>> getRecipesByCategory(String categoryId);
  Future<List<RecipeModel>> getRecipesByUser(String userId);
  Future<RecipeModel> getRecipeById(String id);
  Future<String> createRecipe(RecipeModel recipe);
  Future<void> updateRecipe(RecipeModel recipe);
  Future<void> deleteRecipe(String id);
  Future<List<RecipeModel>> searchRecipes(String query);
  Stream<List<RecipeModel>> watchRecipes();
}

class FirebaseRecipeDataSourceImpl implements FirebaseRecipeDataSource {
  final FirebaseFirestore _firestore;
  final String _collection = 'recipes';

  FirebaseRecipeDataSourceImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<RecipeModel>> getAllRecipes() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => RecipeModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw ServerException('Failed to get recipes: ${e.toString()}');
    }
  }

  @override
  Future<List<RecipeModel>> getRecipesByCategory(String categoryId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('categoryId', isEqualTo: categoryId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => RecipeModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw ServerException(
        'Failed to get recipes by category: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<RecipeModel>> getRecipesByUser(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => RecipeModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw ServerException('Failed to get recipes by user: ${e.toString()}');
    }
  }

  @override
  Future<RecipeModel> getRecipeById(String id) async {
    try {
      final docSnapshot = await _firestore
          .collection(_collection)
          .doc(id)
          .get();

      if (!docSnapshot.exists) {
        throw NotFoundException('Recipe with id $id not found');
      }

      return RecipeModel.fromFirestore(docSnapshot);
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw ServerException('Failed to get recipe: ${e.toString()}');
    }
  }

  @override
  Future<String> createRecipe(RecipeModel recipe) async {
    try {
      final docRef = await _firestore
          .collection(_collection)
          .add(recipe.toFirestore());
      return docRef.id;
    } catch (e) {
      throw ServerException('Failed to create recipe: ${e.toString()}');
    }
  }

  @override
  Future<void> updateRecipe(RecipeModel recipe) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(recipe.id)
          .update(recipe.toFirestore());
    } catch (e) {
      throw ServerException('Failed to update recipe: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteRecipe(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw ServerException('Failed to delete recipe: ${e.toString()}');
    }
  }

  @override
  Future<List<RecipeModel>> searchRecipes(String query) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThanOrEqualTo: '$query\uf8ff')
          .orderBy('title')
          .get();

      return querySnapshot.docs
          .map((doc) => RecipeModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw ServerException('Failed to search recipes: ${e.toString()}');
    }
  }

  @override
  Stream<List<RecipeModel>> watchRecipes() {
    try {
      return _firestore
          .collection(_collection)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => RecipeModel.fromFirestore(doc))
                .toList(),
          );
    } catch (e) {
      throw ServerException('Failed to watch recipes: ${e.toString()}');
    }
  }
}
