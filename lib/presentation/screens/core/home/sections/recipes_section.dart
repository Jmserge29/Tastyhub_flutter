import 'package:flutter/material.dart';
import 'package:flutter_tastyhub/domain/entities/receipe.dart';
import 'package:flutter_tastyhub/presentation/screens/core/detail_recipe/detail_recipe.dart';
import 'package:flutter_tastyhub/presentation/widgets/recipe/horizontal_scroll_recipe.dart';

class RecipesSection extends StatefulWidget {
  const RecipesSection({
    super.key,
    required this.title,
    required this.recipes, // Agregar lista de recetas
    this.onRecipeTap,
    this.onFavoriteToggle,
    this.onSeeAll,
    this.itemWidth = 110,
    this.itemHeight = 140,
  });

  final String title;
  final List<Recipe> recipes;
  final ValueChanged<Recipe>? onRecipeTap;
  final ValueChanged<Recipe>? onFavoriteToggle;
  final VoidCallback? onSeeAll;
  final double itemWidth;
  final double itemHeight;

  @override
  State<RecipesSection> createState() => _RecipesSectionState();
}

class _RecipesSectionState extends State<RecipesSection> {
  void _onRecipeTap(Recipe recipe) {
    // Usar callback personalizado si existe, sino usar default
    if (widget.onRecipeTap != null) {
      widget.onRecipeTap!(recipe);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Seleccionaste: ${recipe.title}')));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DetailRecipeScreen()),
      );
    }
  }

  void _onFavoriteToggle(Recipe recipe) {
    // Usar callback personalizado si existe, sino usar default
    if (widget.onFavoriteToggle != null) {
      widget.onFavoriteToggle!(recipe);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            true
                ? '❤️ Agregaste ${recipe.title} a favoritos'
                : '💔 Eliminaste ${recipe.title} de favoritos',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Si no hay recetas, no mostrar nada
    if (widget.recipes.isEmpty) {
      return const SizedBox.shrink();
    }

    // No usar SingleChildScrollView aquí, el HorizontalRecipesList ya maneja su propio scroll
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: HorizontalRecipesList(
        title: widget.title, // ✅ Usar el título dinámico
        recipes: widget.recipes, // ✅ Usar las recetas pasadas como parámetro
        itemWidth: widget.itemWidth,
        itemHeight: widget.itemHeight,
        onRecipeTap: _onRecipeTap,
        onFavoriteToggle: _onFavoriteToggle,
        onSeeAll: widget.onSeeAll,
      ),
    );
  }
}
