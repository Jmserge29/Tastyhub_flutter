import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tastyhub/domain/entities/category.dart';

class CategoryModel extends Category {
  CategoryModel({
    required super.id,
    required super.name,
    required super.description,
    required super.available,
    required super.createdAt,
  });

  // Crear desde Firestore Document
  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return CategoryModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      available: data['available'] ?? true,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map, String id) {
    return CategoryModel(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      available: map['available'] ?? true,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : DateTime.now(),
    );
  }

  factory CategoryModel.fromEntity(Category category) {
    return CategoryModel(
      id: category.id,
      name: category.name,
      description: category.description,
      available: category.available,
      createdAt: category.createdAt,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'available': available,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'available': available,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    String? description,
    bool? available,
    DateTime? createdAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      available: available ?? this.available,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Category toEntity() {
    return Category(
      id: id,
      name: name,
      description: description,
      available: available,
      createdAt: createdAt,
    );
  }
}
