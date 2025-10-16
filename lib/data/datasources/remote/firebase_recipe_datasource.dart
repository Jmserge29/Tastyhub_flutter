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
  Future<void> toggleLike(String recipeId, String userId);
  Future<List<RecipeModel>> getLikedRecipesByUser(String userId);
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
  Future<void> toggleLike(String recipeId, String userId) async {
    try {
      final docRef = _firestore.collection(_collection).doc(recipeId);
      final doc = await docRef.get();

      if (!doc.exists) {
        throw NotFoundException('Recipe not found');
      }

      final data = doc.data()!;
      final likedByUsers = List<String>.from(data['likedByUsers'] ?? []);

      if (likedByUsers.contains(userId)) {
        // Ya le dio like, remover (unlike)
        await docRef.update({
          'likedByUsers': FieldValue.arrayRemove([userId]),
          'likesCount': FieldValue.increment(-1),
        });
      } else {
        // No le ha dado like, agregar
        await docRef.update({
          'likedByUsers': FieldValue.arrayUnion([userId]),
          'likesCount': FieldValue.increment(1),
        });
      }
    } catch (e) {
      throw ServerException('Failed to toggle like: ${e.toString()}');
    }
  }

  @override
  Future<List<RecipeModel>> getLikedRecipesByUser(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('likedByUsers', arrayContains: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => RecipeModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw ServerException('Failed to get liked recipes: ${e.toString()}');
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

      if (querySnapshot.docs.isEmpty) {
        return [];
      }

      final recipes = querySnapshot.docs.map((doc) {
        try {
          return RecipeModel.fromFirestore(doc);
        } catch (e) {
          rethrow;
        }
      }).toList();

      return recipes;
    } on FirebaseException catch (e) {
      // Error específico de índice faltante
      if (e.code == 'failed-precondition') {
        throw ServerException(
          'Se requiere un índice en Firestore. Revisa la consola para el link.',
        );
      }

      throw ServerException('Error de Firebase: ${e.message}');
    } catch (e) {
      throw ServerException(
        'Error al obtener recetas del usuario: ${e.toString()}',
      );
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
