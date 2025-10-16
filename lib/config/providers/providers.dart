import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_tastyhub/data/datasources/remote/firebase_auth_datasource.dart';
import 'package:flutter_tastyhub/data/datasources/remote/firebase_category_datasource.dart';
import 'package:flutter_tastyhub/data/datasources/remote/firebase_ingredient_datasource.dart';
import 'package:flutter_tastyhub/data/datasources/remote/firebase_recipe_datasource.dart';
import 'package:flutter_tastyhub/data/datasources/remote/firebase_storage_datasource.dart';
import 'package:flutter_tastyhub/data/repositories/repository_auth_impl.dart';
import 'package:flutter_tastyhub/data/repositories/repository_category_impl.dart';
import 'package:flutter_tastyhub/data/repositories/repository_ingredient_impl.dart';
import 'package:flutter_tastyhub/data/repositories/repository_recipe_impl.dart';
import 'package:flutter_tastyhub/data/repositories/repository_storage_impl.dart';
import 'package:flutter_tastyhub/domain/entities/category.dart';
import 'package:flutter_tastyhub/domain/entities/receipe.dart';
import 'package:flutter_tastyhub/domain/entities/user.dart';
import 'package:flutter_tastyhub/domain/repositories/auth_repository.dart';
import 'package:flutter_tastyhub/domain/repositories/category_category.dart';
import 'package:flutter_tastyhub/domain/repositories/ingredient_repository.dart';
import 'package:flutter_tastyhub/domain/repositories/recipe_repository.dart';
import 'package:flutter_tastyhub/domain/repositories/storage_repository.dart';
import 'package:flutter_tastyhub/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:flutter_tastyhub/domain/usecases/auth/login_usecase.dart';
import 'package:flutter_tastyhub/domain/usecases/auth/logout_usecase.dart';
import 'package:flutter_tastyhub/domain/usecases/auth/register_usecase.dart';
import 'package:flutter_tastyhub/domain/usecases/auth/user_usecase.dart';
import 'package:flutter_tastyhub/domain/usecases/categories/get_categories_usecase.dart';
import 'package:flutter_tastyhub/domain/usecases/recipes/create_recipe_usecase.dart';
import 'package:flutter_tastyhub/domain/usecases/recipes/get_recipe_by_id_usecase.dart';
import 'package:flutter_tastyhub/domain/usecases/recipes/get_recipes_by_user_usecase.dart';
import 'package:flutter_tastyhub/domain/usecases/recipes/get_recipes_usecase.dart';
import 'package:flutter_tastyhub/domain/usecases/recipes/search_recipes_usecase.dart';
import 'package:flutter_tastyhub/domain/usecases/recipes/toggle_likes_usecase.dart';

final firebaseAuthDataSourceProvider = Provider<FirebaseAuthDataSource>((ref) {
  return FirebaseAuthDataSourceImpl();
});

final firebaseRecipeDataSourceProvider = Provider<FirebaseRecipeDataSource>((
  ref,
) {
  return FirebaseRecipeDataSourceImpl();
});

final firebaseCategoryDataSourceProvider = Provider<FirebaseCategoryDataSource>(
  (ref) {
    return FirebaseCategoryDataSourceImpl();
  },
);

final firebaseIngredientDataSourceProvider =
    Provider<FirebaseIngredientDataSource>((ref) {
      return FirebaseIngredientDataSourceImpl();
    });

final firebaseStorageDataSourceProvider = Provider<FirebaseStorageDataSource>((
  ref,
) {
  return FirebaseStorageDataSourceImpl();
});

// ========== REPOSITORIES ==========

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.watch(firebaseAuthDataSourceProvider);
  return AuthRepositoryImpl(dataSource: dataSource);
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final dataSource = ref.watch(firebaseCategoryDataSourceProvider);
  return CategoryRepositoryImpl(dataSource: dataSource);
});

final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  final dataSource = ref.watch(firebaseRecipeDataSourceProvider);
  return RecipeRepositoryImpl(dataSource: dataSource);
});

final ingredientRepositoryProvider = Provider<IngredientRepository>((ref) {
  final dataSource = ref.watch(firebaseIngredientDataSourceProvider);
  return IngredientRepositoryImpl(dataSource: dataSource);
});

final storageRepositoryProvider = Provider<StorageRepository>((ref) {
  final dataSource = ref.watch(firebaseStorageDataSourceProvider);
  return StorageRepositoryImpl(dataSource: dataSource);
});

final userRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.watch(firebaseAuthDataSourceProvider);
  return AuthRepositoryImpl(dataSource: dataSource);
});

final categoriesProvider = FutureProvider<List<Category>>((ref) {
  final useCase = ref.watch(getCategoriesUseCaseProvider);
  return useCase.call();
});

// ========== USE CASES ==========

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return RegisterUseCase(repository);
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LogoutUseCase(repository);
});

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetCurrentUserUseCase(repository);
});

final createRecipeUseCaseProvider = Provider<CreateRecipeUseCase>((ref) {
  final recipeRepository = ref.watch(recipeRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return CreateRecipeUseCase(recipeRepository, storageRepository);
});

final getRecipesUseCaseProvider = Provider<GetRecipesUseCase>((ref) {
  final repository = ref.watch(recipeRepositoryProvider);
  return GetRecipesUseCase(repository);
});

final getRecipeByIdUseCaseProvider = Provider<GetRecipeByIdUseCase>((ref) {
  final repository = ref.watch(recipeRepositoryProvider);
  return GetRecipeByIdUseCase(repository);
});

final getRecipesByUserUseCaseProvider = Provider<GetRecipesByUserUseCase>((
  ref,
) {
  final repository = ref.watch(recipeRepositoryProvider);
  return GetRecipesByUserUseCase(repository);
});

final searchRecipesUseCaseProvider = Provider<SearchRecipesUseCase>((ref) {
  final repository = ref.watch(recipeRepositoryProvider);
  return SearchRecipesUseCase(repository);
});

// ========== USE CASES DE USUARIOS ==========

final followUserUseCaseProvider = Provider<FollowUserUseCase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return FollowUserUseCase(repository);
});

final unfollowUserUseCaseProvider = Provider<UnfollowUserUseCase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return UnfollowUserUseCase(repository);
});

final getUserByIdUseCaseProvider = Provider<GetUserByIdUseCase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return GetUserByIdUseCase(repository);
});

// ========== USE CASES DE CATEGORÍAS  ==========

final getCategoriesUseCaseProvider = Provider<GetCategoriesUseCase>((ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  return GetCategoriesUseCase(repository);
});

final getAvailableCategoriesUseCaseProvider =
    Provider<GetAvailableCategoriesUseCase>((ref) {
      final repository = ref.watch(categoryRepositoryProvider);
      return GetAvailableCategoriesUseCase(repository);
    });

// ========== STATE PROVIDERS DE CATEGORÍAS ==========

// Solo categorías disponibles
final availableCategoriesProvider = FutureProvider<List<Category>>((ref) {
  final useCase = ref.watch(getAvailableCategoriesUseCaseProvider);
  return useCase.call();
});

// Stream de categorías (tiempo real)
final categoriesStreamProvider = StreamProvider<List<Category>>((ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  return repository.watchCategories();
});

// ========== STATE PROVIDERS ==========

// Stream del estado de autenticación
final authStateProvider = StreamProvider<User?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges();
});

// Usuario actual
final currentUserProvider = FutureProvider<User?>((ref) {
  final useCase = ref.watch(getCurrentUserUseCaseProvider);
  return useCase.call();
});

// Lista de recetas
final recipesProvider = FutureProvider<List<Recipe>>((ref) {
  final useCase = ref.watch(getRecipesUseCaseProvider);
  return useCase.call();
});

// Stream de recetas en tiempo real
final recipesStreamProvider = StreamProvider<List<Recipe>>((ref) {
  final repository = ref.watch(recipeRepositoryProvider);
  return repository.watchRecipes();
});

final toggleLikeUseCaseProvider = Provider<ToggleLikeUseCase>((ref) {
  final repository = ref.watch(recipeRepositoryProvider);
  return ToggleLikeUseCase(repository);
});

final getLikedRecipesUseCaseProvider = Provider<GetLikedRecipesByUserUseCase>((
  ref,
) {
  final repository = ref.watch(recipeRepositoryProvider);
  return GetLikedRecipesByUserUseCase(repository);
});

// Provider para recetas que le gustan al usuario actual
final userLikedRecipesProvider = FutureProvider<List<Recipe>>((ref) async {
  final currentUser = await ref.watch(getCurrentUserUseCaseProvider).call();
  if (currentUser == null) return [];

  final useCase = ref.watch(getLikedRecipesUseCaseProvider);
  return useCase.call(currentUser.id);
});

// Estado de búsqueda
final searchQueryProvider = StateProvider<String>((ref) => '');

// Resultados de búsqueda
final searchResultsProvider = FutureProvider<List<Recipe>>((ref) {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return <Recipe>[];

  final useCase = ref.watch(searchRecipesUseCaseProvider);
  return useCase.call(query);
});

// ========== PROVIDERS DE USUARIOS ==========

// Provider para obtener un usuario por ID
final userByIdProvider = FutureProvider.family<User?, String>((
  ref,
  userId,
) async {
  final useCase = ref.watch(getUserByIdUseCaseProvider);
  return useCase.call(userId);
});

// Provider para verificar si el usuario actual sigue a otro usuario
final isFollowingProvider = FutureProvider.family<bool, String>((
  ref,
  targetUserId,
) async {
  final currentUser = await ref.watch(getCurrentUserUseCaseProvider).call();
  if (currentUser == null) return false;

  final repository = ref.watch(userRepositoryProvider);
  return repository.isFollowing(currentUser.id, targetUserId);
});

// Provider para obtener seguidores de un usuario
final userFollowersProvider = FutureProvider.family<List<User>, String>((
  ref,
  userId,
) async {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getFollowers(userId);
});

// Provider para obtener usuarios seguidos
final userFollowingProvider = FutureProvider.family<List<User>, String>((
  ref,
  userId,
) async {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getFollowing(userId);
});

// Stream de un usuario específico
final userStreamProvider = StreamProvider.family<User?, String>((ref, userId) {
  final repository = ref.watch(userRepositoryProvider);
  return repository.watchUser(userId);
});

// ========== PROVIDERS DE RECETAS POR USUARIO ==========

// Provider para obtener las recetas de un usuario específico
final userRecipesProvider = FutureProvider.family<List<Recipe>, String>((
  ref,
  userId,
) async {
  final useCase = ref.watch(getRecipesByUserUseCaseProvider);
  return useCase.call(userId);
});

// Provider para contar las recetas de un usuario
final userRecipesCountProvider = FutureProvider.family<int, String>((
  ref,
  userId,
) async {
  final recipes = await ref.watch(userRecipesProvider(userId).future);
  return recipes.length;
});

// ========== NOTIFIERS PARA ESTADOS COMPLEJOS ==========

// Estados de autenticación
enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({AuthStatus? status, User? user, String? errorMessage}) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// Notifier para manejar autenticación
class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;

  AuthNotifier({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
  }) : super(const AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final user = await loginUseCase.call(email, password);
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> register(String email, String password, String name) async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final user = await registerUseCase.call(email, password, name);
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> logout() async {
    try {
      await logoutUseCase.call();
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        user: null,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}

// Provider del AuthNotifier
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  final loginUseCase = ref.watch(loginUseCaseProvider);
  final registerUseCase = ref.watch(registerUseCaseProvider);
  final logoutUseCase = ref.watch(logoutUseCaseProvider);

  return AuthNotifier(
    loginUseCase: loginUseCase,
    registerUseCase: registerUseCase,
    logoutUseCase: logoutUseCase,
  );
});
