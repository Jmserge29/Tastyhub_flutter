import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tastyhub/config/providers/providers.dart';
import 'package:flutter_tastyhub/presentation/widgets/button_create_recipe.dart';
import 'package:flutter_tastyhub/presentation/widgets/user_information.dart';
import 'package:flutter_tastyhub/presentation/widgets/category/category_item.dart';
import 'package:flutter_tastyhub/presentation/widgets/form/custom_input_form_field.dart';
import 'package:flutter_tastyhub/presentation/screens/core/home/sections/recipes_section.dart';
import 'package:flutter_tastyhub/presentation/screens/core/home/sections/categories_section.dart';

class PrincipalScreen extends ConsumerWidget {
  PrincipalScreen({super.key});

  // Mantener solo las categorías quemadas (mientras no tengas categorías en Firebase)
  final List<CategoryModel> recommendedCategories = [
    CategoryModel(id: '1', name: 'Italian', icon: Icons.local_pizza),
    CategoryModel(id: '2', name: 'Chinese', icon: Icons.rice_bowl),
    CategoryModel(id: '3', name: 'Mexican', icon: Icons.local_activity),
    CategoryModel(id: '4', name: 'Desserts', icon: Icons.cake),
    CategoryModel(id: '5', name: 'Healthy', icon: Icons.eco),
    CategoryModel(id: '6', name: 'Fast Food', icon: Icons.fastfood),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 🔥 AQUÍ TRAEMOS LAS RECETAS REALES DE FIREBASE
    final recipesAsync = ref.watch(recipesStreamProvider);

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
                    UserInformation(),
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
                    CustomInputFormField(
                      hintText: 'Buscar recetas...',
                      borderColor: Colors.transparent,
                      prefixIcon: const Icon(Icons.search),
                      onChanged: (value) {
                        // TODO: Implementar búsqueda con Firebase
                        // ref.read(searchQueryProvider.notifier).state = value;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Categorías (mantener quemadas por ahora)
                    CategoriesSection(categories: recommendedCategories),

                    const SizedBox(height: 4),

                    // 🔥 RECETAS DESDE FIREBASE
                    recipesAsync.when(
                      data: (recipes) {
                        if (recipes.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40.0),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.restaurant,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'No hay recetas aún',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('¡Crea la primera receta!'),
                                ],
                              ),
                            ),
                          );
                        }

                        return Column(
                          children: [
                            // Recetas recientes (todas las recetas)
                            RecipesSection(
                              title: 'Recetas recientes',
                              recipes: recipes,
                            ),

                            const SizedBox(height: 4),

                            // Recetas recomendadas (solo las que tienen rating > 4.0)
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

                            // Recetas populares (las que son favoritas)
                            RecipesSection(
                              title: 'Recetas populares',
                              recipes: recipes.toList(),
                            ),

                            const SizedBox(height: 4),

                            // Recetas rápidas (menos de 30 minutos)
                            if (recipes
                                .where((r) => r.prepTime < 30)
                                .isNotEmpty)
                              RecipesSection(
                                title: 'Recetas rápidas',
                                recipes: recipes
                                    .where((r) => r.prepTime < 30)
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
                              Text(
                                'Error al cargar recetas',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('$error'),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  // Refrescar datos
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
