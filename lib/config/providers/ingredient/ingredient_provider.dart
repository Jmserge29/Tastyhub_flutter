import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_tastyhub/data/datasources/remote/firebase_ingredient_datasource.dart';
import 'package:flutter_tastyhub/data/repositories/repository_ingredient_impl.dart';

import 'package:flutter_tastyhub/domain/repositories/ingredient_repository.dart';

// ========== DATASOURCE ==========
final firebaseIngredientDataSourceProvider =
    Provider<FirebaseIngredientDataSource>((ref) {
      return FirebaseIngredientDataSourceImpl();
    });

// ========== REPOSITORY ==========
final ingredientRepositoryProvider = Provider<IngredientRepository>((ref) {
  final ds = ref.watch(firebaseIngredientDataSourceProvider);
  return IngredientRepositoryImpl(dataSource: ds);
});
