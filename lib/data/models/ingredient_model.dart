import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tastyhub/domain/entities/ingredient.dart';

class IngredientModel extends Ingredient {
  IngredientModel({required super.id, required super.name});

  factory IngredientModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return IngredientModel(id: doc.id, name: data['name'] ?? '');
  }

  factory IngredientModel.fromMap(Map<String, dynamic> map, String id) {
    return IngredientModel(id: id, name: map['name'] ?? '');
  }

  factory IngredientModel.fromEntity(Ingredient ingredient) {
    return IngredientModel(id: ingredient.id, name: ingredient.name);
  }

  Map<String, dynamic> toFirestore() {
    return {'name': name};
  }

  @override
  Map<String, dynamic> toMap() {
    return {'name': name};
  }

  IngredientModel copyWith({String? id, String? name}) {
    return IngredientModel(id: id ?? this.id, name: name ?? this.name);
  }

  // Convertir a entidad del dominio
  Ingredient toEntity() {
    return Ingredient(id: id, name: name);
  }
}
