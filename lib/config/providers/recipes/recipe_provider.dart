import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_tastyhub/config/providers/providers.dart';
import 'package:flutter_tastyhub/data/datasources/remote/firebase_recipe_datasource.dart';
import 'package:flutter_tastyhub/data/repositories/repository_recipe_impl.dart';
import 'package:flutter_tastyhub/domain/entities/receipe.dart';
import 'package:flutter_tastyhub/domain/repositories/recipe_repository.dart';
import 'package:flutter_tastyhub/domain/usecases/recipes/create_recipe_usecase.dart';
import 'package:flutter_tastyhub/domain/usecases/recipes/delete_recipe_usecase.dart';
import 'package:flutter_tastyhub/domain/usecases/recipes/get_recipe_by_id_usecase.dart';
import 'package:flutter_tastyhub/domain/usecases/recipes/get_recipes_usecase.dart';
import 'package:flutter_tastyhub/domain/usecases/recipes/get_recipes_by_user_usecase.dart';
import 'package:flutter_tastyhub/domain/usecases/recipes/search_recipes_usecase.dart';
import 'package:flutter_tastyhub/domain/usecases/recipes/toggle_likes_usecase.dart';
import 'package:flutter_tastyhub/domain/usecases/recipes/update_recipe_usecase.dart';

// ========== DATASOURCE ==========
final firebaseRecipeDataSourceProvider = Provider<FirebaseRecipeDataSource>((
  ref,
) {
  return FirebaseRecipeDataSourceImpl();
});

// ========== REPOSITORY ==========
final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  final ds = ref.watch(firebaseRecipeDataSourceProvider);
  return RecipeRepositoryImpl(dataSource: ds);
});

// ========== USE CASES ==========
final createRecipeUseCaseProvider = Provider<CreateRecipeUseCase>((ref) {
  return CreateRecipeUseCase(
    ref.watch(recipeRepositoryProvider),
    ref.watch(storageRepositoryProvider),
  );
});

final deleteRecipeUseCaseProvider = Provider<DeleteRecipeUseCase>((ref) {
  return DeleteRecipeUseCase(
    ref.watch(recipeRepositoryProvider),
    ref.watch(storageRepositoryProvider),
  );
});

final updateRecipeUseCaseProvider = Provider<UpdateRecipeUseCase>((ref) {
  return UpdateRecipeUseCase(
    ref.watch(recipeRepositoryProvider),
    ref.watch(storageRepositoryProvider),
  );
});

final getRecipesUseCaseProvider = Provider<GetRecipesUseCase>((ref) {
  return GetRecipesUseCase(ref.watch(recipeRepositoryProvider));
});

final getRecipeByIdUseCaseProvider = Provider<GetRecipeByIdUseCase>((ref) {
  return GetRecipeByIdUseCase(ref.watch(recipeRepositoryProvider));
});

final getRecipesByUserUseCaseProvider = Provider<GetRecipesByUserUseCase>((
  ref,
) {
  return GetRecipesByUserUseCase(ref.watch(recipeRepositoryProvider));
});

final searchRecipesUseCaseProvider = Provider<SearchRecipesUseCase>((ref) {
  return SearchRecipesUseCase(ref.watch(recipeRepositoryProvider));
});

final toggleLikeUseCaseProvider = Provider<ToggleLikeUseCase>((ref) {
  return ToggleLikeUseCase(ref.watch(recipeRepositoryProvider));
});

final getLikedRecipesUseCaseProvider = Provider<GetLikedRecipesByUserUseCase>((
  ref,
) {
  return GetLikedRecipesByUserUseCase(ref.watch(recipeRepositoryProvider));
});

// ========== STATE ==========
final recipesProvider = FutureProvider<List<Recipe>>((ref) {
  return ref.watch(getRecipesUseCaseProvider).call();
});

final recipesStreamProvider = StreamProvider<List<Recipe>>((ref) {
  return ref.watch(recipeRepositoryProvider).watchRecipes();
});

// Búsqueda
final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider<List<Recipe>>((ref) {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return <Recipe>[];
  return ref.watch(searchRecipesUseCaseProvider).call(query);
});

// Likes del usuario actual
final userLikedRecipesProvider = FutureProvider<List<Recipe>>((ref) async {
  final currentUser = await ref.watch(getCurrentUserUseCaseProvider).call();
  if (currentUser == null) return [];
  return ref.watch(getLikedRecipesUseCaseProvider).call(currentUser.id);
});

// Recetas por usuario
final userRecipesProvider = FutureProvider.family<List<Recipe>, String>((
  ref,
  userId,
) {
  return ref.watch(getRecipesByUserUseCaseProvider).call(userId);
});

final userRecipesCountProvider = FutureProvider.family<int, String>((
  ref,
  userId,
) async {
  final recipes = await ref.watch(userRecipesProvider(userId).future);
  return recipes.length;
});
