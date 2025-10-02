class Category {
  final String id;
  final String name;
  final String description;
  final bool available;
  final DateTime createdAt;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.available,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'available': available,
      'createdAt': createdAt,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map, String id) {
    return Category(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      available: map['available'] ?? true,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }
}
