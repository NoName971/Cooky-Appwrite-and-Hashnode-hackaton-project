import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserModel {
  final String email;
  final String name;
  final String uid;
  final List favorites;
  final bool isVerified;
  UserModel({
    required this.email,
    required this.name,
    required this.uid,
    this.favorites = const [],
    this.isVerified = false,
  });

  UserModel copyWith(
      {String? email,
      String? name,
      String? uid,
      List? favorites,
      bool? isVerified}) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      uid: uid ?? this.uid,
      favorites: favorites ?? this.favorites,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'email': email});
    result.addAll({'name': name});
    result.addAll({'uid': uid});
    result.addAll({'favorites': favorites});

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      uid: map['uid'] ?? '',
      favorites: map['favorites'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(email: $email, name: $name, uid: $uid, favorites: $favorites)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.email == email &&
        other.name == name &&
        other.uid == uid &&
        listEquals(other.favorites, favorites);
  }

  @override
  int get hashCode {
    return email.hashCode ^ name.hashCode ^ uid.hashCode ^ favorites.hashCode;
  }
}
