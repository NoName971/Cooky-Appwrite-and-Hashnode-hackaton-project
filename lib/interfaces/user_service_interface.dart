import 'dart:async';

import 'package:hackaton_v1/models/like.dart';
import 'package:hackaton_v1/models/recipe_model.dart';

import '../models/failure.dart';
import '../models/user_model.dart';
import 'package:appwrite/models.dart' as model;

abstract class IUserService {
  Future<({Failure? failure, model.Document? userData})> saveUserData({
    required UserModel userModel,
  });

  Future<({Failure? failure, List? favorites})> addFavorite({
    required String recipeId,
  });
  Future<({Failure? failure, List? favorites})> removeFavorite({
    required String recipeId,
  });
  Future<List> getFavorites();

  FutureOr deleteRecipe({
    required String recipeId,
  });
  Future<List<RecipeModel>> getUserRecipes();
  Future<List<model.Document>> getLike({
    required String recipeId,
  });
  Future<({Like? like, Failure? failure})> dbCreateLike({
    required String recipeId,
  });
  Future<({bool hasSucceded, Failure? failure})> dbRemoveLike({
    required String likeId,
  });
  Future<({bool hasSucceded, Failure? failure})> updateUserData({
    required Map data,
    required String uid,
  });
}
