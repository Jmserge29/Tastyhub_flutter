class User {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;
  final DateTime createdAt;
  final bool isActive;
  final List<String> followers;
  final List<String> following;
  final String? bio;
  final String? role;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    required this.createdAt,
    this.isActive = true,
    this.followers = const [],
    this.following = const [],
    this.bio,
    this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'isActive': isActive,
      'followers': followers,
      'following': following,
      'bio': bio,
      'role': role,
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
      followers: List<String>.from(map['followers'] ?? []),
      following: List<String>.from(map['following'] ?? []),
      bio: map['bio'],
      role: map['role'],
    );
  }

  // Métodos útiles
  int get followersCount => followers.length;
  int get followingCount => following.length;

  bool isFollowing(String userId) => following.contains(userId);
  bool hasFollower(String userId) => followers.contains(userId);
}
