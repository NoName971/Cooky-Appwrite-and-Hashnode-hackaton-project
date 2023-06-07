import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackaton_v1/features/favorite/views/favorite_view.dart';
import 'package:hackaton_v1/main.dart';
import 'package:hackaton_v1/models/recipe_model.dart';
import '../../../constants/ui_messages.dart';
import '../../../core/utils.dart';
import '../../../services/recipe_service.dart';
import '../../../services/user_service.dart';
import '../../discover/views/recipe_view.dart';

final favoritesProvider =
    StateNotifierProvider<FavoriteController, bool>((ref) {
  final recipeService = ref.watch(recipeServiceProvider);
  final userService = ref.watch(userServiceProvider);
  return FavoriteController(
    recipeService: recipeService,
    userService: userService,
  );
});

class FavoriteController extends StateNotifier<bool> {
  final RecipeService _recipeService;
  final UserService _userService;

  FavoriteController({
    required RecipeService recipeService,
    required UserService userService,
  })  : _recipeService = recipeService,
        _userService = userService,
        super(false);

  Future<void> addFavorite({
    required String recipeId,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    state = !state;

    final response = await _userService.addFavorite(recipeId: recipeId);
    state = !state;

    if (response.failure != null) {
      if (context.mounted) {
        showSnackBar(
          context,
          response.failure?.message ?? UiMessages.unexpectedError,
        );
      }
    } else {
      ref
          .read(favoritesIdsProvider.notifier)
          .update((state) => [...response.favorites!]);
    }
  }

  Future<void> removeFavorite({
    required String recipeId,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    state = !state;
    final response = await _userService.removeFavorite(recipeId: recipeId);
    state = !state;

    if (response.failure != null) {
      if (context.mounted) {
        showSnackBar(
          context,
          response.failure?.message ?? UiMessages.unexpectedError,
        );
      }
    } else {
      List<RecipeModel> favoritesRecipes = [];
      for (final recipeId in response.favorites!) {
        final recipe = await _recipeService.getRecipe(recipeId: recipeId);
        favoritesRecipes.add(recipe.recipe!);
      }
      ref
          .read(favoritesRecipesProvider.notifier)
          .update((state) => [...favoritesRecipes]);
      if (context.mounted) {
        showSnackBar(context, 'Deleted successfully');
      }
    }
  }

  Future<void> deleteRecipe({
    required String recipeId,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    state = !state;
    final response = await _userService.deleteRecipe(recipeId: recipeId);
    state = !state;

    if (response.failure != null) {
      if (context.mounted) {
        showSnackBar(
          context,
          response.failure?.message ?? UiMessages.unexpectedError,
        );
      }
    } else {
      final recipes = ref.read(userRecipesProvider)
        ..removeWhere(
          (element) => element.id == recipeId,
        );

      ref.read(userRecipesProvider.notifier).update((state) => [...recipes]);

      if (context.mounted) {
        showSnackBar(context, 'Deleted successfully');
      }
    }
  }

  Future<void> getUserRecipes({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    try {
      state = !state;
      final recipesIds = await _userService.getFavorites();
      final userRecipes = await _userService.getUserRecipes();

      List<RecipeModel> favoritesRecipes = [];
      for (final recipeId in recipesIds) {
        final recipe = await _recipeService.getRecipe(recipeId: recipeId);
        if (recipe.failure != null) {
          await _userService.removeFavorite(recipeId: recipeId);
        } else {
          favoritesRecipes.add(recipe.recipe!);
        }
      }
      state = !state;
      logger.d(userRecipes.length);
      ref
          .read(favoritesRecipesProvider.notifier)
          .update((state) => [...favoritesRecipes]);
      ref
          .read(userRecipesProvider.notifier)
          .update((state) => [...userRecipes]);
    } catch (e) {
      state = !state;
      if (context.mounted) {
        showSnackBar(context, e.toString());
      }
    }
  }

  // Future<void> getUserRecipes({
  //   required BuildContext context,
  //   required WidgetRef ref,
  // }) async {
  //   try {
  //     state = !state;
  //     final userRecipes = await _userService.getUserRecipes();
  //     state = !state;
  //     ref
  //         .read(userRecipesProvider.notifier)
  //         .update((state) => [...userRecipes]);
  //   } catch (e) {
  //     if (context.mounted) {
  //       showSnackBar(context, e.toString());
  //     }
  //   }
  // }
}
