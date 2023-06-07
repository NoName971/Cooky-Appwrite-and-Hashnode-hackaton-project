import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackaton_v1/core/utils.dart';
import 'package:hackaton_v1/main.dart';
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
      final uid = (await _authService.currentUser())!.$id;

      final ingredientsToString = ingredients.join(" ");
      final queryableString = '$ingredientsToString $title';

      final RecipeModel recipeModel = RecipeModel(
        id: '',
        uid: uid,
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
          showSnackBar(context, 'Recipe created successfully');
          logger.d(response.document!.data);
        }
      } else {
        if (context.mounted) {
          logger.d(response.failure!.message);
          logger.d(response.failure!.stackTrace);

          showSnackBar(context, response.failure!.message);
        }
      }
    } catch (e, stackTrace) {
      state = false;
      logger.d(stackTrace);
      logger.d(e);
      showSnackBar(context, e.toString());
    }
  }

  Future<String> uploadAttachment({
    required String fileName,
    required String filePath,
    String? index,
  }) async {
    final uploadedImage = await _storageService.uploadFile(
      filePath,
      fileName,
      index: index ?? '',
    );
    return uploadedImage;
  }

  Future<void> deleteAttachment(String fileId) async {
    return await _storageService.deleteFile(fileId);
  }
}
