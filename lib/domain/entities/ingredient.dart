class Ingredient {
  final String id;
  final String name;

  Ingredient({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(id: map['id'] ?? '', name: map['name'] ?? '');
  }
}
