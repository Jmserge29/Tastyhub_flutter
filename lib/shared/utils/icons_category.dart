import 'package:flutter/material.dart';

IconData getCategoryIcon(String categoryName) {
  final Map<String, IconData> iconMap = {
    'Italiana': Icons.local_pizza,
    'Mexicana': Icons.local_activity,
    'Asiática': Icons.rice_bowl,
    'Americana': Icons.fastfood,
    'Mediterránea': Icons.restaurant,
    'India': Icons.restaurant_menu,
    'Japonesa': Icons.ramen_dining,
    'Francesa': Icons.bakery_dining,
    'Postres': Icons.cake,
    'Saludable': Icons.eco,
    'Vegetariana': Icons.spa,
    'Vegana': Icons.energy_savings_leaf,
    'Mariscos': Icons.set_meal,
    'Carnes': Icons.outdoor_grill,
    'Desayunos': Icons.free_breakfast,
    'Ensaladas': Icons.lunch_dining,
    'Sopas': Icons.soup_kitchen,
    'Bebidas': Icons.local_drink,
    'Snacks': Icons.cookie,
    'Panadería': Icons.bakery_dining,
  };

  return iconMap[categoryName] ?? Icons.restaurant;
}
