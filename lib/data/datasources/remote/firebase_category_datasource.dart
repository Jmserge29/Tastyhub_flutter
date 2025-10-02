import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tastyhub/data/models/category_model.dart';
import 'package:flutter_tastyhub/shared/errors/failures.dart';

abstract class FirebaseCategoryDataSource {
  Future<List<CategoryModel>> getAllCategories();
  Future<List<CategoryModel>> getAvailableCategories();
  Future<CategoryModel> getCategoryById(String id);
  Future<String> createCategory(CategoryModel category);
  Future<void> updateCategory(CategoryModel category);
  Future<void> deleteCategory(String id);
  Stream<List<CategoryModel>> watchCategories();
}

class FirebaseCategoryDataSourceImpl implements FirebaseCategoryDataSource {
  final FirebaseFirestore _firestore;
  final String _collection = 'categories';

  FirebaseCategoryDataSourceImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .orderBy('name')
          .get();

      return querySnapshot.docs
          .map((doc) => CategoryModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw ServerException('Failed to get categories: ${e.toString()}');
    }
  }

  @override
  Future<List<CategoryModel>> getAvailableCategories() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('available', isEqualTo: true)
          .orderBy('name')
          .get();

      return querySnapshot.docs
          .map((doc) => CategoryModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw ServerException(
        'Failed to get available categories: ${e.toString()}',
      );
    }
  }

  @override
  Future<CategoryModel> getCategoryById(String id) async {
    try {
      final docSnapshot = await _firestore
          .collection(_collection)
          .doc(id)
          .get();

      if (!docSnapshot.exists) {
        throw NotFoundException('Category with id $id not found');
      }

      return CategoryModel.fromFirestore(docSnapshot);
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw ServerException('Failed to get category: ${e.toString()}');
    }
  }

  @override
  Future<String> createCategory(CategoryModel category) async {
    try {
      final docRef = await _firestore
          .collection(_collection)
          .add(category.toFirestore());
      return docRef.id;
    } catch (e) {
      throw ServerException('Failed to create category: ${e.toString()}');
    }
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(category.id)
          .update(category.toFirestore());
    } catch (e) {
      throw ServerException('Failed to update category: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw ServerException('Failed to delete category: ${e.toString()}');
    }
  }

  @override
  Stream<List<CategoryModel>> watchCategories() {
    try {
      return _firestore
          .collection(_collection)
          .orderBy('name')
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => CategoryModel.fromFirestore(doc))
                .toList(),
          );
    } catch (e) {
      throw ServerException('Failed to watch categories: ${e.toString()}');
    }
  }
}
