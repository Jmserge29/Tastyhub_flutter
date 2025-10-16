class Recipe {
  final String id;
  final String title;
  final String description;
  final List<String> ingredients;
  final String imageUrl;
  final int prepTime;
  final String categoryId;
  final String userId;
  final DateTime createdAt;
  final int likesCount;
  final List<String> likedByUsers;

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
    this.likesCount = 0,
    this.likedByUsers = const [],
  });

  bool isLikedBy(String userId) {
    return likedByUsers.contains(userId);
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'ingredients': ingredients,
      'imageUrl': imageUrl,
      'prepTime': prepTime,
      'categoryId': categoryId,
      'userId': userId,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'likesCount': likesCount,
      'likedByUsers': likedByUsers,
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
      likesCount: map['likesCount'] ?? 0,
      likedByUsers: map['likedByUsers'] != null
          ? List<String>.from(map['likedByUsers'])
          : [],
    );
  }
}
