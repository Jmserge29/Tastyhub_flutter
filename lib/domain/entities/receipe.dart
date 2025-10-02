class Recipe {
  final String id;
  final String title;
  final String description;
  final List<String> ingredients;
  final String imageUrl;
  final int prepTime;
  final String userId;
  final DateTime createdAt;
  final String categoryId;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.imageUrl,
    required this.prepTime,
    required this.categoryId,
    required this.userId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'ingredients': ingredients,
      'imageUrl': imageUrl,
      'prepTime': prepTime,
      'userId': userId,
      'categoryId': categoryId,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map, String id) {
    return Recipe(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      ingredients: List<String>.from(map['ingredients'] ?? []),
      imageUrl: map['imageUrl'] ?? '',
      prepTime: map['prepTime']?.toInt() ?? 0,
      categoryId: map['categoryId'] ?? '',
      userId: map['userId'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }
}
