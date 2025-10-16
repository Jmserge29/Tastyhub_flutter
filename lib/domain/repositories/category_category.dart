import 'package:flutter_tastyhub/domain/entities/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> getAllCategories();
  Future<List<Category>> getAvailableCategories();
  Future<Category> getCategoryById(String id);
  Future<String> createCategory(Category category);
  Future<void> updateCategory(Category category);
  Future<void> deleteCategory(String id);
  Stream<List<Category>> watchCategories();
}
