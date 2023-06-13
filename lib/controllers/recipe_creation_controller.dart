import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackaton_v1/helpers/utils.dart';
import 'package:hackaton_v1/models/recipe_model.dart';
import 'package:hackaton_v1/services/auth_service.dart';
import 'package:hackaton_v1/services/recipe_service.dart';
import 'package:hackaton_v1/services/storage_service.dart';

final recipeCreationProvider =
    StateNotifierProvider<RecipeCreationController, bool>((ref) {
  final authService = ref.watch(authServiceProvider);
  final recipeService = ref.watch(recipeServiceProvider);
  final storageService = ref.watch(storageServiceProvider);
  return RecipeCreationController(
    authService: authService,
    recipeService: recipeService,
    storageService: storageService,
  );
});

class RecipeCreationController extends StateNotifier<bool> {
  final AuthService _authService;
  final RecipeService _recipeService;
  final StorageService _storageService;
  RecipeCreationController({
    required AuthService authService,
    required RecipeService recipeService,
    required StorageService storageService,
  })  : _authService = authService,
        _recipeService = recipeService,
        _storageService = storageService,
        super(false);

  Future<void> createRecipe({
    required String title,
    required String description,
    required String illustrationPic,
    required List<String> ingredients,
    required String cookingTime,
    required List<String> cookingSteps,
    required List<String> cookingStepsPics,
    required BuildContext context,
  }) async {
    try {
      state = true;
      final user = (await _authService.getCurrentUser())!;

      final ingredientsToString = ingredients.join(" ");
      final queryableString = '$ingredientsToString $title';

      final RecipeModel recipeModel = RecipeModel(
        userName: user.name,
        id: '',
        uid: user.$id,
        title: title,
        description: description,
        illustrationPic: illustrationPic,
        ingredients: ingredients,
        cookingTime: cookingTime,
        cookingSteps: cookingSteps,
        cookingStepsPics: cookingStepsPics,
        queryableString: queryableString,
        likes: 0,
      );
      final response =
          await _recipeService.createRecipe(recipeModel: recipeModel);
      state = false;
      if (response.document != null) {
        if (context.mounted) {
          Navigator.pop(context);
          showSnackBar(context, 'Recipe created successfully');
        }
      } else {
        if (context.mounted) {
          showSnackBar(context, response.failure!.message);
        }
      }
    } catch (e) {
      state = false;
      showSnackBar(context, e.toString());
    }
  }

  Future<void> updateRecipe({
    required RecipeModel recipeModel,
    required BuildContext context,
  }) async {
    try {
      state = true;
      final ingredientsToString = recipeModel.ingredients.join(" ");
      final title = recipeModel.title;
      final queryableString = '$title $ingredientsToString';

      final recipe = recipeModel.copyWith(queryableString: queryableString);

      final response = await _recipeService.updateRecipe(
        recipeId: recipe.id,
        data: recipe.toMap(),
      );
      state = false;
      if (response.hasSucceded) {
        if (context.mounted) {
          showSnackBar(context, 'Recipe updated successfully');
          Navigator.pop(context);
        }
      } else {
        if (context.mounted) {
          showSnackBar(context, response.failure!.message);
        }
      }
    } catch (e) {
      state = false;
      showSnackBar(context, e.toString());
    }
  }

  Future<String> uploadAttachment({
    required String fileName,
    required String filePath,
  }) async {
    final uploadedImage = await _storageService.uploadFile(
      filePath,
      fileName,
    );
    return uploadedImage;
  }

  Future<void> deleteAttachment(String fileId) async {
    return await _storageService.deleteFile(fileId);
  }
}
