import 'package:cloud_firestore/cloud_firestore.dart';

// Modèle utilisé par l'application pour représenter le profil utilisateur.
// Firebase Auth gère le compte, mais Firestore garde ces infos applicatives.
class UserModel {
  const UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.emailVerified,
    required this.createdAt,
    this.profileImageUrl,
  });

  final String uid;
  final String fullName;
  final String email;
  final bool emailVerified;
  final DateTime createdAt;
  // URL de la photo stockée dans Firebase Storage, utilisée par la Home.
  final String? profileImageUrl;

  // Transforme les données lues depuis Firestore en objet Dart.
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      emailVerified: map['emailVerified'] as bool? ?? false,
      createdAt: _readDate(map['createdAt']),
      profileImageUrl: map['profileImageUrl'] as String?,
    );
  }

  // Transforme l'objet Dart en Map pour l'enregistrer dans Firestore.
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'emailVerified': emailVerified,
      'createdAt': Timestamp.fromDate(createdAt),
      'profileImageUrl': profileImageUrl,
    };
  }

  // Permet de modifier une partie du modèle sans tout reconstruire à la main.
  UserModel copyWith({
    String? uid,
    String? fullName,
    String? email,
    bool? emailVerified,
    DateTime? createdAt,
    String? profileImageUrl,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      emailVerified: emailVerified ?? this.emailVerified,
      createdAt: createdAt ?? this.createdAt,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  // Firestore stocke les dates sous forme de Timestamp. Cette méthode accepte
  // aussi DateTime ou String pour rendre la lecture plus robuste.
  static DateTime _readDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }
}
