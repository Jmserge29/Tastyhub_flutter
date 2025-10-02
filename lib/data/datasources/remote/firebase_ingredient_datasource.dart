import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tastyhub/data/models/ingredient_model.dart';
import 'package:flutter_tastyhub/shared/errors/failures.dart';

abstract class FirebaseIngredientDataSource {
  Future<List<IngredientModel>> getAllIngredients();
  Future<IngredientModel> getIngredientById(String id);
  Future<String> createIngredient(IngredientModel ingredient);
  Future<void> updateIngredient(IngredientModel ingredient);
  Future<void> deleteIngredient(String id);
  Future<List<IngredientModel>> searchIngredients(String query);
  Stream<List<IngredientModel>> watchIngredients();
}

class FirebaseIngredientDataSourceImpl implements FirebaseIngredientDataSource {
  final FirebaseFirestore _firestore;
  final String _collection = 'ingredients';

  FirebaseIngredientDataSourceImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<IngredientModel>> getAllIngredients() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .orderBy('name')
          .get();

      return querySnapshot.docs
          .map((doc) => IngredientModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw ServerException('Failed to get ingredients: ${e.toString()}');
    }
  }

  @override
  Future<IngredientModel> getIngredientById(String id) async {
    try {
      final docSnapshot = await _firestore
          .collection(_collection)
          .doc(id)
          .get();

      if (!docSnapshot.exists) {
        throw NotFoundException('Ingredient with id $id not found');
      }

      return IngredientModel.fromFirestore(docSnapshot);
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw ServerException('Failed to get ingredient: ${e.toString()}');
    }
  }

  @override
  Future<String> createIngredient(IngredientModel ingredient) async {
    try {
      final docRef = await _firestore
          .collection(_collection)
          .add(ingredient.toFirestore());
      return docRef.id;
    } catch (e) {
      throw ServerException('Failed to create ingredient: ${e.toString()}');
    }
  }

  @override
  Future<void> updateIngredient(IngredientModel ingredient) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(ingredient.id)
          .update(ingredient.toFirestore());
    } catch (e) {
      throw ServerException('Failed to update ingredient: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteIngredient(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw ServerException('Failed to delete ingredient: ${e.toString()}');
    }
  }

  @override
  Future<List<IngredientModel>> searchIngredients(String query) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .orderBy('name')
          .get();

      return querySnapshot.docs
          .map((doc) => IngredientModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw ServerException('Failed to search ingredients: ${e.toString()}');
    }
  }

  @override
  Stream<List<IngredientModel>> watchIngredients() {
    try {
      return _firestore
          .collection(_collection)
          .orderBy('name')
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => IngredientModel.fromFirestore(doc))
                .toList(),
          );
    } catch (e) {
      throw ServerException('Failed to watch ingredients: ${e.toString()}');
    }
  }
}
