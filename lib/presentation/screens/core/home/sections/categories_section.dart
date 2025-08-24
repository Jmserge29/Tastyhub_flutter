import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tastyhub/presentation/shared/category/category_item.dart';

class CategoriesSection extends StatelessWidget {
  final List<CategoryModel> categories;
  final String title;
  final ValueChanged<CategoryModel>? onCategoryTap;
  final double itemSize;
  final double itemSpacing;
  final EdgeInsetsGeometry? padding;
  final TextStyle? titleStyle;
  final TextStyle? itemTextStyle;

  const CategoriesSection({
    super.key,
    required this.categories,
    this.title = 'CATEGORÍAS',
    this.onCategoryTap,
    this.itemSize = 46,
    this.itemSpacing = 8,
    this.padding,
    this.titleStyle,
    this.itemTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Título
        Padding(
          padding:
              padding?.resolve(TextDirection.ltr) ??
              const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style:
                titleStyle ??
                const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: Color.fromARGB(255, 108, 108, 108),
                ),
          ),
        ),
        const SizedBox(height: 16),

        // Lista horizontal de categorías
        SizedBox(
          height: itemSize + 40, // Espacio para círculo + texto
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            separatorBuilder: (context, index) => SizedBox(width: itemSpacing),
            itemBuilder: (context, index) {
              final category = categories[index];
              return CategoryItem(
                category: category,
                size: itemSize,
                iconSize: itemSize * 0.5, // 35% del tamaño del círculo
                textStyle: itemTextStyle,
                onTap: () => onCategoryTap?.call(category),
              );
            },
          ),
        ),
      ],
    );
  }
}
