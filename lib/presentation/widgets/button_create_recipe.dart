import 'package:flutter/material.dart';
import 'package:flutter_tastyhub/presentation/screens/core/create_recipe/create_recipe.dart';

class ButtonCreateRecipe extends StatelessWidget {
  const ButtonCreateRecipe({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateRecipeScreen()),
          );
        },
        backgroundColor: const Color.fromARGB(255, 145, 93, 86),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
