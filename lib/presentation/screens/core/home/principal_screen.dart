import 'package:flutter/material.dart';
import 'package:flutter_tastyhub/presentation/screens/core/home/sections/categories_section.dart';
import 'package:flutter_tastyhub/presentation/screens/core/home/sections/recipes_section.dart';
import 'package:flutter_tastyhub/presentation/shared/user_information.dart';

class PrincipalScreen extends StatelessWidget {
  const PrincipalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            UserInformation(),
            Text('Descubre tu próxima receta'),
            CategoriesSection(),
            RecipesSection(title: 'Recetas recientes'),
            RecipesSection(title: 'Recetas recomendadas'),
            RecipesSection(title: 'Recetas populares'),
          ],
        ),
      ),
    );
  }
}
