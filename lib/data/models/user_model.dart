import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_tastyhub/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.profileImageUrl,
    required super.createdAt,
    super.isActive = true,
    super.followers = const [],
    super.following = const [],
    super.bio,
    super.role,
  });

  factory UserModel.fromFirebaseUser(firebase_auth.User firebaseUser) {
    return UserModel(
      id: firebaseUser.uid,
      name: firebaseUser.displayName ?? '',
      email: firebaseUser.email ?? '',
      profileImageUrl: firebaseUser.photoURL,
      createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
      isActive: true,
      followers: [],
      following: [],
      bio: null,
      role: null,
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      profileImageUrl: data['profileImageUrl'],
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      isActive: data['isActive'] ?? true,
      followers: data['followers'] != null
          ? List<String>.from(data['followers'])
          : [],
      following: data['following'] != null
          ? List<String>.from(data['following'])
          : [],
      bio: data['bio'],
      role: data['role'],
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profileImageUrl: map['profileImageUrl'],
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : DateTime.now(),
      isActive: map['isActive'] ?? true,
      followers: map['followers'] != null
          ? List<String>.from(map['followers'])
          : [],
      following: map['following'] != null
          ? List<String>.from(map['following'])
          : [],
      bio: map['bio'],
      role: map['role'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'createdAt': FieldValue.serverTimestamp(),
      'isActive': isActive,
      'followers': followers,
      'following': following,
      'bio': bio,
      'role': role,
    };
  }

  @override
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

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImageUrl,
    DateTime? createdAt,
    bool? isActive,
    List<String>? followers,
    List<String>? following,
    String? bio,
    String? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      bio: bio ?? this.bio,
      role: role ?? this.role,
    );
  }

  // Convertir a entidad del dominio
  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      profileImageUrl: profileImageUrl,
      createdAt: createdAt,
      isActive: isActive,
      followers: followers,
      following: following,
      bio: bio,
      role: role,
    );
  }
}
