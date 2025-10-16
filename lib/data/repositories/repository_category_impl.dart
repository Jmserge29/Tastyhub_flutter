import 'package:flutter_tastyhub/data/datasources/remote/firebase_category_datasource.dart';
import 'package:flutter_tastyhub/data/models/category_model.dart';
import 'package:flutter_tastyhub/domain/entities/category.dart';
import 'package:flutter_tastyhub/domain/repositories/category_category.dart';
import 'package:flutter_tastyhub/shared/errors/failures.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final FirebaseCategoryDataSource dataSource;

  CategoryRepositoryImpl({required this.dataSource});

  @override
  Future<List<Category>> getAllCategories() async {
    try {
      final categoryModels = await dataSource.getAllCategories();
      return categoryModels.map((model) => model.toEntity()).toList();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('Failed to get categories: ${e.toString()}');
    }
  }

  @override
  Future<List<Category>> getAvailableCategories() async {
    try {
      final categoryModels = await dataSource.getAvailableCategories();
      return categoryModels.map((model) => model.toEntity()).toList();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(
        'Failed to get available categories: ${e.toString()}',
      );
    }
  }

  @override
  Future<Category> getCategoryById(String id) async {
    try {
      final categoryModel = await dataSource.getCategoryById(id);
      return categoryModel.toEntity();
    } on NotFoundException catch (e) {
      throw NotFoundFailure(e.message);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('Failed to get category: ${e.toString()}');
    }
  }

  @override
  Future<String> createCategory(Category category) async {
    try {
      final categoryModel = CategoryModel.fromEntity(category);
      return await dataSource.createCategory(categoryModel);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('Failed to create category: ${e.toString()}');
    }
  }

  @override
  Future<void> updateCategory(Category category) async {
    try {
      final categoryModel = CategoryModel.fromEntity(category);
      await dataSource.updateCategory(categoryModel);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('Failed to update category: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    try {
      await dataSource.deleteCategory(id);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('Failed to delete category: ${e.toString()}');
    }
  }

  @override
  Stream<List<Category>> watchCategories() {
    try {
      return dataSource.watchCategories().map(
        (categoryModels) =>
            categoryModels.map((model) => model.toEntity()).toList(),
      );
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('Failed to watch categories: ${e.toString()}');
    }
  }
}
