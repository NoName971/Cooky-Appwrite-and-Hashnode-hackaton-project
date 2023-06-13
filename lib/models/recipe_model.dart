import 'package:collection/collection.dart';

class RecipeModel {
  final String id;
  final String uid;
  final String title;
  final String description;
  final String illustrationPic;
  final List<String> ingredients;
  final String cookingTime;
  final List<String> cookingSteps;
  final List<String> cookingStepsPics;
  final int likes;
  final String? createdAt;
  final String? updatedAt;
  final String? queryableString;
  final int views;

  RecipeModel({
    required this.id,
    required this.uid,
    required this.title,
    required this.description,
    required this.illustrationPic,
    required this.ingredients,
    required this.cookingTime,
    required this.cookingSteps,
    required this.cookingStepsPics,
    required this.likes,
    this.views = 0,
    this.createdAt,
    this.updatedAt,
    this.queryableString,
  });

  RecipeModel copyWith({
    String? id,
    String? uid,
    String? title,
    String? description,
    String? illustrationPic,
    List<String>? ingredients,
    String? cookingTime,
    List<String>? cookingSteps,
    List<String>? cookingStepsPics,
    int? likes,
    String? createdAt,
    String? updatedAt,
    String? queryableString,
  }) {
    return RecipeModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      title: title ?? this.title,
      description: description ?? this.description,
      illustrationPic: illustrationPic ?? this.illustrationPic,
      ingredients: ingredients ?? this.ingredients,
      cookingTime: cookingTime ?? this.cookingTime,
      cookingSteps: cookingSteps ?? this.cookingSteps,
      cookingStepsPics: cookingStepsPics ?? this.cookingStepsPics,
      likes: likes ?? this.likes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      queryableString: queryableString ?? this.queryableString,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'uid': uid});
    result.addAll({'title': title});
    result.addAll({'description': description});
    result.addAll({'illustrationPic': illustrationPic});
    result.addAll({'ingredients': ingredients});
    result.addAll({'cookingTime': cookingTime});
    result.addAll({'cookingSteps': cookingSteps});
    result.addAll({'cookingStepsPics': cookingStepsPics});
    if (createdAt != null) {
      result.addAll({'createdAt': createdAt});
    }
    if (updatedAt != null) {
      result.addAll({'updatedAt': updatedAt});
    }
    if (queryableString != null) {
      result.addAll({'queryableString': queryableString});
    }

    return result;
  }

  factory RecipeModel.fromMap(Map<String, dynamic> map) {
    return RecipeModel(
      id: map['\$id'] ?? '',
      uid: map['uid'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      illustrationPic: map['illustrationPic'] ?? '',
      ingredients: List<String>.from(map['ingredients']),
      cookingTime: map['cookingTime'] ?? '',
      cookingSteps: List<String>.from(map['cookingSteps']),
      cookingStepsPics: List<String>.from(map['cookingStepsPics']),
      likes: map['likes']?.toInt() ?? 0,
      views: map['views']?.toInt() ?? 0,
      createdAt: map['\$createdAt'],
      updatedAt: map['\$updatedAt'],
      queryableString: map['queryableString'],
    );
  }

  @override
  String toString() {
    return 'RecipeModel(id: $id, uid: $uid, title: $title, description: $description, illustrationPic: $illustrationPic, ingredients: $ingredients, cookingTime: $cookingTime, cookingSteps: $cookingSteps, cookingStepsPics: $cookingStepsPics, likes: $likes, createdAt: $createdAt, updatedAt: $updatedAt, queryableString: $queryableString)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is RecipeModel &&
        other.id == id &&
        other.uid == uid &&
        other.title == title &&
        other.description == description &&
        other.illustrationPic == illustrationPic &&
        listEquals(other.ingredients, ingredients) &&
        other.cookingTime == cookingTime &&
        listEquals(other.cookingSteps, cookingSteps) &&
        listEquals(other.cookingStepsPics, cookingStepsPics) &&
        other.likes == likes &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.queryableString == queryableString;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uid.hashCode ^
        title.hashCode ^
        description.hashCode ^
        illustrationPic.hashCode ^
        ingredients.hashCode ^
        cookingTime.hashCode ^
        cookingSteps.hashCode ^
        cookingStepsPics.hashCode ^
        likes.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        queryableString.hashCode;
  }
}
