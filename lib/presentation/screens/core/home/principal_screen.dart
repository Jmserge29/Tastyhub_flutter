import 'package:flutter/material.dart';
import 'package:flutter_tastyhub/presentation/shared/button_create_recipe.dart';
import 'package:flutter_tastyhub/presentation/shared/user_information.dart';
import 'package:flutter_tastyhub/presentation/shared/recipe/recipe_card.dart';
import 'package:flutter_tastyhub/presentation/shared/category/category_item.dart';
import 'package:flutter_tastyhub/presentation/shared/form/custom_input_form_field.dart';
import 'package:flutter_tastyhub/presentation/screens/core/home/sections/recipes_section.dart';
import 'package:flutter_tastyhub/presentation/screens/core/home/sections/categories_section.dart';

class PrincipalScreen extends StatelessWidget {
  PrincipalScreen({super.key});

  final List<Recipe> recentRecipes = [
    Recipe(
      id: '1',
      name: 'Spaghetti Carbonara',
      author: 'Chef Mario',
      imageUrl:
          'https://www.elespectador.com/resizer/v2/DNKJ2AFQ4VBBVIEQ5ICCXCXO34.jpg?auth=f3bb96795db65e379eaea4de12a38d5df8017da3f5d9518738aa87e502c68dc5&width=920&height=613&smart=true&quality=60',
    ),
    Recipe(
      id: '2',
      name: 'Pizza Margherita',
      author: 'Chef Giuseppe',
      imageUrl:
          'https://www.supermaxi.com/wp-content/uploads/2024/07/shutterstock_2476903001-1024x683.jpg.webp',
    ),
    Recipe(
      id: '3',
      name: 'Tiramisu',
      author: 'Chef Luigi',
      imageUrl:
          'https://www.recetasnestle.com.ec/sites/default/files/styles/recipe_detail_desktop_new/public/srh_recipes/7f45d6f8807ebc775928651a3398dce9.png?itok=Xgr1MAc_',
    ),
    Recipe(
      id: '4',
      name: 'Panna Cotta',
      author: 'Chef Marco',
      imageUrl:
          'https://static01.nyt.com/images/2023/08/10/multimedia/LH-Panna-Cotta-wczm/LH-Panna-Cotta-wczm-mediumSquareAt3X.jpg',
    ),
  ];

  final List<CategoryModel> recommendedCategories = [
    CategoryModel(id: '1', name: 'Italian', icon: Icons.local_pizza),
    CategoryModel(id: '2', name: 'Chinese', icon: Icons.rice_bowl),
    CategoryModel(id: '3', name: 'Mexican', icon: Icons.local_activity),
    CategoryModel(id: '1', name: 'Italian', icon: Icons.local_pizza),
    CategoryModel(id: '2', name: 'Chinese', icon: Icons.rice_bowl),
    CategoryModel(id: '3', name: 'Mexican', icon: Icons.local_activity),
  ];

  @override
  Widget build(BuildContext context) {
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
                        // Lógica de búsqueda
                      },
                    ),
                    const SizedBox(height: 20),
                    CategoriesSection(categories: recommendedCategories),
                    const SizedBox(height: 4),
                    RecipesSection(
                      title: 'Recetas recientes',
                      recipes: recentRecipes,
                    ),
                    const SizedBox(height: 4),
                    RecipesSection(
                      title: 'Recetas recomendadas',
                      recipes: [recentRecipes[0]],
                    ),
                    const SizedBox(height: 4),
                    RecipesSection(
                      title: 'Recetas populares',
                      recipes: [...recentRecipes, recentRecipes[1]],
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
