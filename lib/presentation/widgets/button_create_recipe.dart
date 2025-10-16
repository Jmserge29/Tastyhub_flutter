import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tastyhub/config/providers/theme/theme_provider.dart';
import 'package:flutter_tastyhub/presentation/screens/core/create_recipe/create_recipe.dart';

class ButtonCreateRecipe extends ConsumerWidget {
  const ButtonCreateRecipe({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
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
        backgroundColor: theme.themeType.accentColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
