import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tastyhub/domain/entities/receipe.dart';
import 'package:flutter_tastyhub/presentation/widgets/recipe/recipe_card.dart';

/// Widget para scroll horizontal de recetas
class HorizontalRecipesList extends ConsumerWidget {
  final List<Recipe> recipes;
  final String? title;
  final ValueChanged<Recipe>? onRecipeTap;
  final ValueChanged<Recipe>? onFavoriteToggle;
  final double itemWidth;
  final double itemHeight;
  final double itemSpacing;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onSeeAll;

  const HorizontalRecipesList({
    super.key,
    required this.recipes,
    this.title,
    this.onRecipeTap,
    this.onFavoriteToggle,
    this.itemWidth = 200,
    this.itemHeight = 280,
    this.itemSpacing = 16,
    this.padding,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (recipes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) _buildHeader(context),
        SizedBox(
          height: itemHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
            itemCount: recipes.length,
            separatorBuilder: (context, index) => SizedBox(width: itemSpacing),
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return RecipeCard(
                recipe: recipe,
                width: itemWidth,
                height: itemHeight,
                onTap: () => onRecipeTap?.call(recipe),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title!.toUpperCase(),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Color.fromARGB(255, 108, 108, 108),
            ),
          ),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: Text(
                'Ver todo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
