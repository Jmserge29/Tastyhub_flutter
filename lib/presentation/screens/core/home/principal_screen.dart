import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tastyhub/config/providers/providers.dart';
import 'package:flutter_tastyhub/domain/entities/receipe.dart';
import 'package:flutter_tastyhub/presentation/screens/core/home/input_search/input_search_recipes.dart';
import 'package:flutter_tastyhub/presentation/widgets/button_create_recipe.dart';
import 'package:flutter_tastyhub/presentation/widgets/user_information.dart';
import 'package:flutter_tastyhub/presentation/widgets/category/category_item.dart';
import 'package:flutter_tastyhub/presentation/screens/core/home/sections/recipes_section.dart';
import 'package:flutter_tastyhub/presentation/screens/core/home/sections/categories_section.dart';
import 'package:flutter_tastyhub/shared/utils/icons_category.dart';

class PrincipalScreen extends ConsumerStatefulWidget {
  const PrincipalScreen({super.key});

  @override
  ConsumerState<PrincipalScreen> createState() => _PrincipalScreenState();
}

class _PrincipalScreenState extends ConsumerState<PrincipalScreen> {
  String _searchQuery = '';
  List<Recipe> _filteredRecipes = [];
  bool _isSearching = false;

  // Método que se ejecuta cuando el usuario busca (después del debounce)
  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
      _isSearching = query.isNotEmpty;
    });

    if (query.isEmpty) {
      setState(() {
        _filteredRecipes = [];
      });
      return;
    }

    // Filtrar recetas localmente
    _performSearch(query);
  }

  // Lógica de filtrado de recetas
  void _performSearch(String query) {
    final recipesAsync = ref.read(recipesStreamProvider);

    recipesAsync.whenData((allRecipes) {
      final queryLower = query.toLowerCase();

      final filtered = allRecipes.where((recipe) {
        final titleMatch = recipe.title.toLowerCase().contains(queryLower);
        final descriptionMatch = recipe.description.toLowerCase().contains(
          queryLower,
        );
        final ingredientsMatch = recipe.ingredients.any(
          (ingredient) => ingredient.toLowerCase().contains(queryLower),
        );

        return titleMatch || descriptionMatch || ingredientsMatch;
      }).toList();

      setState(() {
        _filteredRecipes = filtered;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Si está buscando, usar recetas filtradas; si no, usar el stream normal
    final recipesAsync = _isSearching
        ? AsyncValue.data(_filteredRecipes)
        : ref.watch(recipesStreamProvider);

    final categoriesAsync = ref.watch(categoriesStreamProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(26, 16, 26, 0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    const UserInformation(),
                    const SizedBox(height: 20),
                    const Text(
                      'Descubre tu próxima receta',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        height: 1.0,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Widget de búsqueda
                    InputSearchRecipes(
                      onSearch: _handleSearch,
                      debounceMilliseconds: 800,
                      hintText: 'Buscar recetas...',
                    ),

                    const SizedBox(height: 20),

                    // Mostrar categorías solo si NO está buscando
                    if (!_isSearching)
                      categoriesAsync.when(
                        data: (categories) {
                          if (categories.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          final categoriesAdapted = categories
                              .map<CategoryModel>(
                                (c) => CategoryModel(
                                  id: c.id,
                                  name: c.name,
                                  icon: getCategoryIcon(c.name),
                                ),
                              )
                              .toList();

                          return CategoriesSection(
                            categories: categoriesAdapted,
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, stack) => Center(
                          child: Text('Error al cargar categorías: $error'),
                        ),
                      ),

                    const SizedBox(height: 4),

                    // Mostrar título de búsqueda si está buscando
                    if (_isSearching) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              size: 20,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _filteredRecipes.isEmpty
                                    ? 'No se encontraron resultados para "$_searchQuery"'
                                    : 'Resultados para "$_searchQuery" (${_filteredRecipes.length})',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Recetas (filtradas o normales)
                    recipesAsync.when(
                      data: (recipes) {
                        if (recipes.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: Column(
                                children: [
                                  Icon(
                                    _isSearching
                                        ? Icons.search_off
                                        : Icons.restaurant,
                                    size: 64,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _isSearching
                                        ? 'No se encontraron recetas'
                                        : 'No hay recetas aún',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _isSearching
                                        ? 'Intenta con otros términos de búsqueda'
                                        : '¡Crea la primera receta!',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        // Si está buscando, mostrar solo resultados
                        if (_isSearching) {
                          return RecipesSection(
                            title: 'Recetas encontradas',
                            recipes: recipes,
                          );
                        }

                        return Column(
                          children: [
                            RecipesSection(
                              title: 'Recetas recientes',
                              recipes: recipes,
                            ),
                            const SizedBox(height: 4),
                            if (recipes
                                .where((r) => r.prepTime > 4.0)
                                .isNotEmpty)
                              RecipesSection(
                                title: 'Recetas recomendadas',
                                recipes: recipes
                                    .where((r) => r.prepTime > 4.0)
                                    .toList(),
                              ),
                            const SizedBox(height: 4),
                            if (recipes
                                .where((r) => r.likesCount > 1)
                                .isNotEmpty)
                              RecipesSection(
                                title: 'Recetas populares',
                                recipes: recipes
                                    .where((r) => r.likesCount > 1)
                                    .toList(),
                              ),
                            const SizedBox(height: 4),
                            if (recipes
                                .where((r) => r.prepTime < 45)
                                .isNotEmpty)
                              RecipesSection(
                                title: 'Recetas rápidas',
                                recipes: recipes
                                    .where((r) => r.prepTime < 45)
                                    .toList(),
                              ),
                          ],
                        );
                      },
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40.0),
                          child: Column(
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text('Cargando recetas...'),
                            ],
                          ),
                        ),
                      ),
                      error: (error, stack) => Center(
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.error,
                                size: 64,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Error al cargar recetas',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('$error'),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  ref.invalidate(recipesStreamProvider);
                                },
                                child: const Text('Reintentar'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const ButtonCreateRecipe(),
    );
  }
}
