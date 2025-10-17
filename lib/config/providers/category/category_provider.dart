import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tastyhub/data/datasources/remote/firebase_category_datasource.dart';
import 'package:flutter_tastyhub/data/repositories/repository_category_impl.dart';
import 'package:flutter_tastyhub/domain/entities/category.dart';
import 'package:flutter_tastyhub/domain/repositories/category_category.dart';
import 'package:flutter_tastyhub/domain/usecases/categories/get_categories_usecase.dart';

// ========== DATASOURCE ==========
final firebaseCategoryDataSourceProvider = Provider<FirebaseCategoryDataSource>(
  (ref) {
    return FirebaseCategoryDataSourceImpl();
  },
);

// ========== REPOSITORY ==========
final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final ds = ref.watch(firebaseCategoryDataSourceProvider);
  return CategoryRepositoryImpl(dataSource: ds);
});

// ========== USE CASES ==========
final getCategoriesUseCaseProvider = Provider<GetCategoriesUseCase>((ref) {
  return GetCategoriesUseCase(ref.watch(categoryRepositoryProvider));
});

final getAvailableCategoriesUseCaseProvider =
    Provider<GetAvailableCategoriesUseCase>((ref) {
      return GetAvailableCategoriesUseCase(
        ref.watch(categoryRepositoryProvider),
      );
    });

// ========== STATE ==========
final categoriesProvider = FutureProvider<List<Category>>((ref) {
  return ref.watch(getCategoriesUseCaseProvider).call();
});

final availableCategoriesProvider = FutureProvider<List<Category>>((ref) {
  return ref.watch(getAvailableCategoriesUseCaseProvider).call();
});

final categoriesStreamProvider = StreamProvider<List<Category>>((ref) {
  return ref.watch(categoryRepositoryProvider).watchCategories();
});
