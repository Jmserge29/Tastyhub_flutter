import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tastyhub/domain/entities/receipe.dart';

class RecipeModel extends Recipe {
  RecipeModel({
    required super.id,
    required super.title,
    required super.description,
    required super.ingredients,
    required super.imageUrl,
    required super.prepTime,
    required super.categoryId,
    required super.userId,
    required super.createdAt,
  });

  // Crear desde Firestore Document
  factory RecipeModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return RecipeModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      ingredients: List<String>.from(data['ingredients'] ?? []),
      imageUrl: data['imageUrl'] ?? '',
      prepTime: (data['prepTime'] ?? 0).toInt(),
      categoryId: data['categoryId'] ?? '',
      userId: data['userId'] ?? '',
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  // Crear desde Map
  factory RecipeModel.fromMap(Map<String, dynamic> map, String id) {
    return RecipeModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      ingredients: List<String>.from(map['ingredients'] ?? []),
      imageUrl: map['imageUrl'] ?? '',
      prepTime: (map['prepTime'] ?? 0).toInt(),
      categoryId: map['categoryId'] ?? '',
      userId: map['userId'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : DateTime.now(),
    );
  }

  factory RecipeModel.fromEntity(Recipe recipe) {
    return RecipeModel(
      id: recipe.id,
      title: recipe.title,
      description: recipe.description,
      ingredients: recipe.ingredients,
      imageUrl: recipe.imageUrl,
      prepTime: recipe.prepTime,
      categoryId: recipe.categoryId,
      userId: recipe.userId,
      createdAt: recipe.createdAt,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'ingredients': ingredients,
      'imageUrl': imageUrl,
      'prepTime': prepTime,
      'categoryId': categoryId,
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  @override
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
    };
  }

  RecipeModel copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? ingredients,
    String? imageUrl,
    int? prepTime,
    String? categoryId,
    String? userId,
    DateTime? createdAt,
  }) {
    return RecipeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      ingredients: ingredients ?? this.ingredients,
      imageUrl: imageUrl ?? this.imageUrl,
      prepTime: prepTime ?? this.prepTime,
      categoryId: categoryId ?? this.categoryId,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Recipe toEntity() {
    return Recipe(
      id: id,
      title: title,
      description: description,
      ingredients: ingredients,
      imageUrl: imageUrl,
      prepTime: prepTime,
      categoryId: categoryId,
      userId: userId,
      createdAt: createdAt,
    );
  }
}
