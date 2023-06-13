import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackaton_v1/constants/appwrite_constants.dart';
import 'package:hackaton_v1/constants/ui_messages.dart';
import 'package:hackaton_v1/constants/appwrite_providers.dart';
import 'package:hackaton_v1/models/failure.dart';
import 'package:appwrite/models.dart' as model;
import 'package:hackaton_v1/models/recipe_model.dart';
import 'package:hackaton_v1/models/user_model.dart';
import 'package:hackaton_v1/services/auth_service.dart';
import '../interfaces/user_service_interface.dart';
import '../models/like.dart';

final userServiceProvider = Provider((ref) {
  final database = ref.watch(appwriteDatabaseProvider);
  final authService = ref.watch(authServiceProvider);
  return UserService(databases: database, authService: authService);
});

class UserService implements IUserService {
  final Databases _databases;
  final AuthService _authService;

  UserService({
    required Databases databases,
    required AuthService authService,
  })  : _databases = databases,
        _authService = authService;
  @override
  Future<({Failure? failure, model.Document? userData})> saveUserData({
    required UserModel userModel,
  }) async {
    try {
      final userData = await _databases.createDocument(
        databaseId: AppwriteConstants.mainDatabaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );

      return (failure: null, userData: userData);
    } on AppwriteException catch (e, stackTrace) {
      return (
        failure: Failure(e.message ?? UiMessages.unexpectedError, stackTrace),
        userData: null
      );
    } catch (e, stackTrace) {
      return (failure: Failure(e.toString(), stackTrace), userData: null);
    }
  }

  @override
  Future<List> getFavorites() async {
    final user = await _authService.getCurrentUser();
    final userData = await _databases.getDocument(
      databaseId: AppwriteConstants.mainDatabaseId,
      collectionId: AppwriteConstants.usersCollectionId,
      documentId: user!.$id,
    );
    final userModel = UserModel.fromMap(userData.data);

    return userModel.favorites;
  }

  @override
  Future<({Failure? failure, List? favorites})> removeFavorite({
    required String recipeId,
  }) async {
    try {
      final user = await _authService.getCurrentUser();
      final userData = await _databases.getDocument(
        databaseId: AppwriteConstants.mainDatabaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId: user!.$id,
      );

      List favorites = UserModel.fromMap(userData.data).favorites
        ..removeWhere(
          (element) => element == recipeId,
        );

      await _databases.updateDocument(
        databaseId: AppwriteConstants.mainDatabaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId: user.$id,
        data: {
          'favorites': favorites,
        },
      );

      return (favorites: favorites, failure: null);
    } on AppwriteException catch (e, stackTrace) {
      return (
        failure: Failure(e.message ?? UiMessages.unexpectedError, stackTrace),
        favorites: null
      );
    } catch (e, stackTrace) {
      return (failure: Failure(e.toString(), stackTrace), favorites: null);
    }
  }

  @override
  Future<({Failure? failure, bool hasSucceded})> deleteRecipe({
    required String recipeId,
  }) async {
    try {
      await _databases.deleteDocument(
        databaseId: AppwriteConstants.mainDatabaseId,
        collectionId: AppwriteConstants.recipeCollectionId,
        documentId: recipeId,
      );

      return (hasSucceded: true, failure: null);
    } on AppwriteException catch (e, stackTrace) {
      return (
        failure: Failure(e.message ?? UiMessages.unexpectedError, stackTrace),
        hasSucceded: false
      );
    } catch (e, stackTrace) {
      return (failure: Failure(e.toString(), stackTrace), hasSucceded: false);
    }
  }

  @override
  Future<({Failure? failure, List? favorites})> addFavorite({
    required String recipeId,
  }) async {
    try {
      final user = await _authService.getCurrentUser();
      final userData = await _databases.getDocument(
        databaseId: AppwriteConstants.mainDatabaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId: user!.$id,
      );

      List favorites = UserModel.fromMap(userData.data).favorites
        ..add(recipeId);

      await _databases.updateDocument(
        databaseId: AppwriteConstants.mainDatabaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId: user.$id,
        data: {
          'favorites': favorites,
        },
      );

      return (favorites: favorites, failure: null);
    } on AppwriteException catch (e, stackTrace) {
      return (
        failure: Failure(e.message ?? UiMessages.unexpectedError, stackTrace),
        favorites: null
      );
    } catch (e, stackTrace) {
      return (failure: Failure(e.toString(), stackTrace), favorites: null);
    }
  }

  @override
  Future<List<RecipeModel>> getUserRecipes() async {
    final user = await _authService.getCurrentUser();
    bool allFetched = false;
    final List<RecipeModel> userRecipes = [];
    while (!allFetched) {
      final response = await _databases.listDocuments(
        databaseId: AppwriteConstants.mainDatabaseId,
        collectionId: AppwriteConstants.recipeCollectionId,
        queries: [
          Query.equal('uid', user!.$id),
          Query.limit(25),
          Query.offset(userRecipes.length)
        ],
      );

      for (final recipe in response.documents) {
        userRecipes.add(RecipeModel.fromMap(recipe.data));
      }
      if (response.documents.length < 25) {
        allFetched = true;
      } else {
        allFetched = false;
      }
    }
    return userRecipes;
  }

  @override
  Future<List<model.Document>> getLike({
    required String recipeId,
  }) async {
    final currentUser = await _authService.getCurrentUser();
    final likes = await _databases.listDocuments(
      databaseId: AppwriteConstants.mainDatabaseId,
      collectionId: AppwriteConstants.likesCollectionId,
      queries: [
        Query.equal('like', ['${currentUser!.$id}$recipeId']),
      ],
    );
    return likes.documents;
  }

  @override
  Future<({Like? like, Failure? failure})> dbCreateLike({
    required String recipeId,
  }) async {
    try {
      final currentUser = await _authService.getCurrentUser();
      final like = await _databases.createDocument(
        databaseId: AppwriteConstants.mainDatabaseId,
        collectionId: AppwriteConstants.likesCollectionId,
        documentId: ID.unique(),
        data: {
          'like': '${currentUser!.$id}$recipeId',
        },
      );
      return (like: Like.fromMap(like.data), failure: null);
    } on AppwriteException catch (e, stackTrace) {
      return (
        failure: Failure(e.message ?? UiMessages.unexpectedError, stackTrace),
        like: null
      );
    } catch (e, stackTrace) {
      return (failure: Failure(e.toString(), stackTrace), like: null);
    }
  }

  @override
  Future<({bool hasSucceded, Failure? failure})> dbRemoveLike({
    required String likeId,
  }) async {
    try {
      await _databases.deleteDocument(
        databaseId: AppwriteConstants.mainDatabaseId,
        collectionId: AppwriteConstants.likesCollectionId,
        documentId: likeId,
      );

      return (hasSucceded: true, failure: null);
    } on AppwriteException catch (e, stackTrace) {
      return (
        failure: Failure(e.message ?? UiMessages.unexpectedError, stackTrace),
        hasSucceded: false
      );
    } catch (e, stackTrace) {
      return (failure: Failure(e.toString(), stackTrace), hasSucceded: false);
    }
  }

  @override
  Future<({bool hasSucceded, Failure? failure})> updateUserData({
    required Map data,
    required String uid,
  }) async {
    try {
      await _databases.updateDocument(
        databaseId: AppwriteConstants.mainDatabaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId: uid,
        data: data,
      );

      return (hasSucceded: true, failure: null);
    } on AppwriteException catch (e, stackTrace) {
      return (
        failure: Failure(e.message ?? UiMessages.unexpectedError, stackTrace),
        hasSucceded: false
      );
    } catch (e, stackTrace) {
      return (failure: Failure(e.toString(), stackTrace), hasSucceded: false);
    }
  }
}
