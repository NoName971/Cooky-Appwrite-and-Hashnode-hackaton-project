import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackaton_v1/constants/appwrite_constants.dart';
import 'package:hackaton_v1/constants/appwrite_providers.dart';
import 'package:hackaton_v1/main.dart';
import 'package:hackaton_v1/models/failure.dart';
import 'package:appwrite/models.dart' as model;
import 'package:hackaton_v1/models/recipe_model.dart';

import '../constants/ui_messages.dart';
import '../interfaces/recipe_service_interface.dart';

final recipeServiceProvider = Provider((ref) {
  final database = ref.watch(appwriteDatabaseProvider);
  return RecipeService(databases: database);
});

class RecipeService extends IRecipeService {
  final Databases _databases;
  RecipeService({
    required Databases databases,
  }) : _databases = databases;

  @override
  Future<({model.Document? document, Failure? failure})> createRecipe({
    required RecipeModel recipeModel,
  }) async {
    try {
      logger.d(recipeModel.toMap());
      final recipe = await _databases.createDocument(
        databaseId: AppwriteConstants.marketplaceDatabaseId,
        collectionId: AppwriteConstants.recipeCollectionId,
        documentId: ID.unique(),
        data: recipeModel.toMap(),
      );

      return (failure: null, document: recipe);
    } on AppwriteException catch (e, stackTrace) {
      return (
        failure: Failure(e.message ?? UiMessages.unexpectedError, stackTrace),
        document: null
      );
    } catch (e, stackTrace) {
      return (failure: Failure(e.toString(), stackTrace), document: null);
    }
  }

  @override
  Future<({Failure? failure, String? response})> deleteRecipe({
    required String recipeId,
  }) async {
    try {
      await _databases.deleteDocument(
        databaseId: AppwriteConstants.marketplaceDatabaseId,
        collectionId: AppwriteConstants.recipeCollectionId,
        documentId: ID.unique(),
      );

      return (failure: null, response: UiMessages.deleted);
    } on AppwriteException catch (e, stackTrace) {
      return (
        failure: Failure(e.message ?? UiMessages.unexpectedError, stackTrace),
        response: null
      );
    } catch (e, stackTrace) {
      return (failure: Failure(e.toString(), stackTrace), response: null);
    }
  }

  @override
  Future<({Failure? failure, model.DocumentList? recipes})> getRecipes({
    required List<String> queries,
  }) async {
    try {
      final recipes = await _databases.listDocuments(
        databaseId: AppwriteConstants.marketplaceDatabaseId,
        collectionId: AppwriteConstants.recipeCollectionId,
        queries: queries,
      );
      return (failure: null, recipes: recipes);
    } on AppwriteException catch (e, stackTrace) {
      return (
        failure: Failure(e.message ?? UiMessages.unexpectedError, stackTrace),
        recipes: null
      );
    } catch (e, stackTrace) {
      return (failure: Failure(e.toString(), stackTrace), recipes: null);
    }
  }

  @override
  Future<({RecipeModel? recipe, Failure? failure})> getRecipe({
    required String recipeId,
  }) async {
    try {
      final recipe = await _databases.getDocument(
        databaseId: AppwriteConstants.marketplaceDatabaseId,
        collectionId: AppwriteConstants.recipeCollectionId,
        documentId: recipeId,
      );

      return (recipe: RecipeModel.fromMap(recipe.data), failure: null);
    } on AppwriteException catch (e, stackTrace) {
      return (
        failure: Failure(e.message ?? UiMessages.unexpectedError, stackTrace),
        recipe: null
      );
    } catch (e, stackTrace) {
      return (failure: Failure(e.toString(), stackTrace), recipe: null);
    }
  }

  Future<({bool hasSucceded, Failure? failure})> updateRecipe({
    required String recipeId,
    required Map data,
  }) async {
    try {
      await _databases.updateDocument(
        databaseId: AppwriteConstants.marketplaceDatabaseId,
        collectionId: AppwriteConstants.recipeCollectionId,
        documentId: recipeId,
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
