class User {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;
  final DateTime createdAt;
  final bool isActive;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    required this.createdAt,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'isActive': isActive,
    };
  }

  factory User.fromMap(Map<String, dynamic> map, String id) {
    return User(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profileImageUrl: map['profileImageUrl'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      isActive: map['isActive'] ?? true,
    );
  }
}
