import 'package:flutter/material.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Categorías'),
        Row(
          children: [
            Chip(label: Text('Categoría 1')),
            SizedBox(width: 8),
            Chip(label: Text('Categoría 2')),
            SizedBox(width: 8),
            Chip(label: Text('Categoría 3')),
          ],
        ),
      ],
    );
  }
}
