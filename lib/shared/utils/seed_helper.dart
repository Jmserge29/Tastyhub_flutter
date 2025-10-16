import 'package:cloud_firestore/cloud_firestore.dart';

class SeedHelper {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Función principal para llenar todo
  static Future<void> seedAll() async {
    print('🔥 Iniciando seed de datos...');

    await seedCategories();
    await seedIngredients();
    await seedRecipes();

    print('✅ ¡Datos cargados exitosamente!');
  }

  // ========== CATEGORÍAS ==========
  static Future<void> seedCategories() async {
    print('📁 Creando categorías...');

    final categories = [
      {
        'name': 'Italiana',
        'description': 'Pizza, pasta, risotto y más delicias de Italia',
        'available': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Mexicana',
        'description': 'Tacos, enchiladas, guacamole y sabores auténticos',
        'available': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Asiática',
        'description': 'Sushi, pad thai, curry y cocina del lejano oriente',
        'available': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Americana',
        'description': 'Hamburguesas, hot dogs, BBQ y comida clásica americana',
        'available': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Mediterránea',
        'description':
            'Hummus, falafel, ensaladas griegas y sabores del mediterráneo',
        'available': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'India',
        'description': 'Curry, naan, samosas y especias aromáticas',
        'available': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Japonesa',
        'description': 'Sushi, ramen, tempura y té matcha',
        'available': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Francesa',
        'description': 'Croissants, quiches, ratatouille y alta cocina',
        'available': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Postres',
        'description': 'Pasteles, galletas, helados y dulces tentaciones',
        'available': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Saludable',
        'description': 'Recetas nutritivas, bajas en calorías y balanceadas',
        'available': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Vegetariana',
        'description': 'Recetas sin carne pero llenas de sabor',
        'available': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Vegana',
        'description': 'Sin productos animales, 100% plant-based',
        'available': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Mariscos',
        'description': 'Pescados, camarones, pulpo y frutos del mar',
        'available': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Carnes',
        'description': 'Res, cerdo, cordero y aves preparadas a la perfección',
        'available': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Desayunos',
        'description': 'Pancakes, huevos, avena y energía para comenzar el día',
        'available': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Ensaladas',
        'description': 'Frescas, coloridas y llenas de vitaminas',
        'available': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Sopas',
        'description': 'Calientes, reconfortantes y nutritivas',
        'available': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Bebidas',
        'description': 'Smoothies, jugos, cócteles y bebidas refrescantes',
        'available': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Snacks',
        'description': 'Bocadillos perfectos entre comidas',
        'available': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Panadería',
        'description': 'Pan casero, bollos, bagels y delicias horneadas',
        'available': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
    ];

    for (var category in categories) {
      await _firestore.collection('categories').add(category);
      print('  ✓ ${category['name']}');
    }
  }

  // ========== INGREDIENTES ==========
  static Future<void> seedIngredients() async {
    print('🥕 Creando ingredientes...');

    final ingredients = [
      'Tomate',
      'Cebolla',
      'Ajo',
      'Aceite de oliva',
      'Sal',
      'Pimienta',
      'Pasta',
      'Arroz',
      'Harina',
      'Huevo',
      'Leche',
      'Mantequilla',
      'Queso mozzarella',
      'Queso parmesano',
      'Pollo',
      'Carne molida',
      'Pescado',
      'Camarones',
      'Aguacate',
      'Limón',
      'Cilantro',
      'Chile',
      'Frijoles',
      'Tortillas',
      'Lechuga',
      'Tomate cherry',
      'Zanahoria',
      'Brócoli',
      'Espinaca',
      'Champiñones',
      'Pimiento',
      'Papas',
      'Azúcar',
      'Chocolate',
      'Vainilla',
      'Crema',
      'Fresas',
      'Plátano',
    ];

    for (var ingredient in ingredients) {
      await _firestore.collection('ingredients').add({'name': ingredient});
      print('  ✓ $ingredient');
    }
  }

  // ========== RECETAS ==========
  static Future<void> seedRecipes() async {
    print('🍳 Creando recetas...');

    final recipes = [
      {
        'name': 'Pizza Margherita',
        'author': 'Chef Mario',
        'imageUrl':
            'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400',
        'isFavorite': true,
        'rating': 4.8,
        'cookingTime': 25,
        'difficulty': 'Medio',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Tacos al Pastor',
        'author': 'Chef Luis',
        'imageUrl':
            'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=400',
        'isFavorite': true,
        'rating': 4.9,
        'cookingTime': 30,
        'difficulty': 'Medio',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Sushi Roll California',
        'author': 'Chef Takeshi',
        'imageUrl':
            'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400',
        'isFavorite': false,
        'rating': 4.6,
        'cookingTime': 45,
        'difficulty': 'Difícil',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Ensalada César',
        'author': 'Chef Ana',
        'imageUrl':
            'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400',
        'isFavorite': false,
        'rating': 4.3,
        'cookingTime': 15,
        'difficulty': 'Fácil',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Hamburguesa Clásica',
        'author': 'Chef Bob',
        'imageUrl':
            'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
        'isFavorite': true,
        'rating': 4.7,
        'cookingTime': 20,
        'difficulty': 'Fácil',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Pad Thai',
        'author': 'Chef Somchai',
        'imageUrl':
            'https://images.unsplash.com/photo-1559314809-0d155014e29e?w=400',
        'isFavorite': false,
        'rating': 4.5,
        'cookingTime': 35,
        'difficulty': 'Medio',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Tiramisu',
        'author': 'Chef Luigi',
        'imageUrl':
            'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=400',
        'isFavorite': true,
        'rating': 4.9,
        'cookingTime': 40,
        'difficulty': 'Medio',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Ramen',
        'author': 'Chef Kenji',
        'imageUrl':
            'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=400',
        'isFavorite': false,
        'rating': 4.8,
        'cookingTime': 50,
        'difficulty': 'Difícil',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Pollo al Curry',
        'author': 'Chef Raj',
        'imageUrl':
            'https://images.unsplash.com/photo-1588166524941-3bf61a9c41db?w=400',
        'isFavorite': false,
        'rating': 4.4,
        'cookingTime': 40,
        'difficulty': 'Medio',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Brownie de Chocolate',
        'author': 'Chef Emma',
        'imageUrl':
            'https://images.unsplash.com/photo-1607920591413-4ec007e70023?w=400',
        'isFavorite': true,
        'rating': 4.7,
        'cookingTime': 35,
        'difficulty': 'Fácil',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Paella Valenciana',
        'author': 'Chef Carlos',
        'imageUrl':
            'https://images.unsplash.com/photo-1534080564583-6be75777b70a?w=400',
        'isFavorite': false,
        'rating': 4.6,
        'cookingTime': 60,
        'difficulty': 'Difícil',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Smoothie Bowl',
        'author': 'Chef Sophie',
        'imageUrl':
            'https://images.unsplash.com/photo-1590301157890-4810ed352733?w=400',
        'isFavorite': false,
        'rating': 4.2,
        'cookingTime': 10,
        'difficulty': 'Fácil',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Lasagna Bolognesa',
        'author': 'Chef Mario',
        'imageUrl':
            'https://images.unsplash.com/photo-1574894709920-11b28e7367e3?w=400',
        'isFavorite': true,
        'rating': 4.8,
        'cookingTime': 90,
        'difficulty': 'Difícil',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Fish and Chips',
        'author': 'Chef Oliver',
        'imageUrl':
            'https://images.unsplash.com/photo-1579208570378-8c970854bc23?w=400',
        'isFavorite': false,
        'rating': 4.4,
        'cookingTime': 30,
        'difficulty': 'Medio',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Guacamole Fresco',
        'author': 'Chef Luis',
        'imageUrl':
            'https://images.unsplash.com/photo-1601924582970-9238bcb495d9?w=400',
        'isFavorite': false,
        'rating': 4.5,
        'cookingTime': 10,
        'difficulty': 'Fácil',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Ceviche Peruano',
        'author': 'Chef Gastón',
        'imageUrl':
            'https://images.unsplash.com/photo-1626645738196-c2a7c87a8f58?w=400',
        'isFavorite': true,
        'rating': 4.9,
        'cookingTime': 20,
        'difficulty': 'Medio',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Pancakes',
        'author': 'Chef Sophie',
        'imageUrl':
            'https://images.unsplash.com/photo-1528207776546-365bb710ee93?w=400',
        'isFavorite': false,
        'rating': 4.6,
        'cookingTime': 20,
        'difficulty': 'Fácil',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Curry Verde Tailandés',
        'author': 'Chef Somchai',
        'imageUrl':
            'https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd?w=400',
        'isFavorite': false,
        'rating': 4.7,
        'cookingTime': 35,
        'difficulty': 'Medio',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Sopa de Tomate',
        'author': 'Chef Ana',
        'imageUrl':
            'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400',
        'isFavorite': false,
        'rating': 4.3,
        'cookingTime': 25,
        'difficulty': 'Fácil',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Fajitas de Pollo',
        'author': 'Chef Luis',
        'imageUrl':
            'https://images.unsplash.com/photo-1599974289471-faab2d06adfa?w=400',
        'isFavorite': true,
        'rating': 4.8,
        'cookingTime': 30,
        'difficulty': 'Fácil',
        'createdAt': FieldValue.serverTimestamp(),
      },
    ];

    for (var recipe in recipes) {
      await _firestore.collection('recipes').add(recipe);
      print('  ✓ ${recipe['name']}');
    }
  }
}
