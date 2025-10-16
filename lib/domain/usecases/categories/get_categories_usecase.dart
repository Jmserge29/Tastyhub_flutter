import 'package:flutter_tastyhub/domain/entities/category.dart';
import 'package:flutter_tastyhub/domain/repositories/category_category.dart';

class GetCategoriesUseCase {
  final CategoryRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<List<Category>> call() async {
    return await repository.getAllCategories();
  }
}

class GetAvailableCategoriesUseCase {
  final CategoryRepository repository;

  GetAvailableCategoriesUseCase(this.repository);

  Future<List<Category>> call() async {
    return await repository.getAvailableCategories();
  }
}

class GetCategoryByIdUseCase {
  final CategoryRepository repository;

  GetCategoryByIdUseCase(this.repository);

  Future<Category> call(String categoryId) async {
    if (categoryId.isEmpty) {
      throw Exception('Category ID cannot be empty');
    }
    return await repository.getCategoryById(categoryId);
  }
}

class WatchCategoriesUseCase {
  final CategoryRepository repository;

  WatchCategoriesUseCase(this.repository);

  Stream<List<Category>> call() {
    return repository.watchCategories();
  }
}
