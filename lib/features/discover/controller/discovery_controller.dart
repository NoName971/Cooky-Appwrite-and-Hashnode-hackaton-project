import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackaton_v1/constants/ui_messages.dart';
import 'package:hackaton_v1/features/discover/views/discovery_view.dart';
import 'package:hackaton_v1/features/discover/views/recipe_view.dart';
import 'package:hackaton_v1/models/recipe_model.dart';
import 'package:hackaton_v1/services/recipe_service.dart';
import 'package:hackaton_v1/services/user_service.dart';
import '../../../core/utils.dart';
import '../../../main.dart';
import '../../../models/failure.dart';
import '../../../models/like.dart';

final discoveryProvider =
    StateNotifierProvider<DiscoveryViewController, DiscoberyControllerState>(
        (ref) {
  final recipeService = ref.watch(recipeServiceProvider);
  final userService = ref.watch(userServiceProvider);

  return DiscoveryViewController(
    userService: userService,
    recipeService: recipeService,
  );
});

final currentRecipeProvider = FutureProvider.autoDispose
    .family<({Failure? failure, RecipeModel? recipe}), String>(
        (ref, recipeId) async {
  final favorites = await ref.read(userServiceProvider).getFavorites();
  final like = await ref.read(userServiceProvider).getLike(recipeId: recipeId);
  if (like.isNotEmpty) {
    ref.read(likeProvider.notifier).update(
          (state) => Like.fromMap(like.first.data).id,
        );
    ref.read(isLikedProvider.notifier).update((state) => true);
  }
  logger.d(favorites);
  ref.watch(favoritesIdsProvider.notifier).update((state) => [...favorites]);

  final recipeService = ref.watch(recipeServiceProvider);
  return recipeService.getRecipe(recipeId: recipeId);
});

class DiscoveryViewController extends StateNotifier<DiscoberyControllerState> {
  final RecipeService _recipeService;
  final UserService _userService;

  DiscoveryViewController({
    required RecipeService recipeService,
    required UserService userService,
  })  : _recipeService = recipeService,
        _userService = userService,
        super(
          const DiscoberyControllerState(),
        );

  Future<void> getRecipes({
    required BuildContext context,
    required List<String> queries,
    required FetchMode fetchMode,
    required WidgetRef ref,
  }) async {
    try {
      state = state.copyWith(
        isLoading: true,
      );

      if (fetchMode == FetchMode.older && state.canFetchMore) {
        state = state.copyWith(
          isFetchingOlder: true,
        );
      }

      final response = await _recipeService.getRecipes(queries: queries);
      if (response.failure != null) {
        state = state.copyWith(
          isLoading: false,
        );
        if (context.mounted) {
          showSnackBar(context, response.failure!.message);
        }
      } else {
        if (fetchMode == FetchMode.normal) {
          List<RecipeModel> newRecipes = [];
          for (final recipe in response.recipes!.documents) {
            newRecipes.add(RecipeModel.fromMap(recipe.data));
          }
          state = state.copyWith(
            isLoading: false,
          );
          ref.read(recipesProvider.notifier).update((state) {
            return [...newRecipes];
          });
        } else if (fetchMode == FetchMode.newer) {
          List<RecipeModel> newRecipes = [];
          final oldRecipes = ref.watch(recipesProvider);
          for (final recipe in response.recipes!.documents) {
            newRecipes.add(RecipeModel.fromMap(recipe.data));
          }
          state = state.copyWith(isLoading: false);
          ref.read(recipesProvider.notifier).update((state) {
            return [...newRecipes, ...oldRecipes];
          });
        } else if (fetchMode == FetchMode.older) {
          List<RecipeModel> newRecipes = [];
          final oldRecipes = ref.watch(recipesProvider);
          for (final recipe in response.recipes!.documents) {
            newRecipes.add(RecipeModel.fromMap(recipe.data));
          }

          ref.read(recipesProvider.notifier).update((state) {
            return [...oldRecipes, ...newRecipes];
          });
          state = state.copyWith(
            canFetchMore: false,
            isLoading: false,
            isFetchingOlder: false,
          );
        }
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isFetchingOlder: false,
      );
      showSnackBar(context, e.toString());
    }
  }

  Future<({Failure? failure, RecipeModel? recipe})> getRecipe({
    required BuildContext context,
    required String recipeId,
  }) async {
    return await _recipeService.getRecipe(recipeId: recipeId);
  }

  Future<void> addFavorite({
    required String recipeId,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final response = await _userService.addFavorite(recipeId: recipeId);
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
    final response = await _userService.removeFavorite(recipeId: recipeId);
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

  Future<void> like({
    required String recipeId,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final response = await _recipeService.getRecipe(recipeId: recipeId);
    if (response.failure == null) {
      final response2 = await _userService.dbCreateLike(recipeId: recipeId);
      if (response2.failure == null) {
        final likeId = response2.like!.id;
        await _recipeService.updateRecipe(recipeId: recipeId, data: {
          'likes': response.recipe!.likes + 1,
        });
        ref.read(likeProvider.notifier).update((state) => likeId);
        ref.read(isLikedProvider.notifier).update((state) => !state);
      }
    } else {
      if (context.mounted) {
        showSnackBar(
          context,
          response.failure?.message ?? UiMessages.unexpectedError,
        );
      }
    }
  }

  Future<void> removeLike({
    required String recipeId,
    required BuildContext context,
    required String likeId,
    required WidgetRef ref,
  }) async {
    final response = await _recipeService.getRecipe(recipeId: recipeId);
    if (response.failure == null) {
      await _userService.dbRemoveLike(likeId: likeId);
      await _recipeService.updateRecipe(recipeId: recipeId, data: {
        'likes': response.recipe!.likes - 1,
      });
      ref.read(isLikedProvider.notifier).update((state) => !state);
    } else {
      if (context.mounted) {
        showSnackBar(
          context,
          response.failure?.message ?? UiMessages.unexpectedError,
        );
      }
    }
  }
}

enum FetchMode { normal, older, newer }

@immutable
class DiscoberyControllerState {
  final bool isLoading;
  final bool canFetchMore;
  final bool isFetchingOlder;
  const DiscoberyControllerState({
    this.isLoading = false,
    this.canFetchMore = true,
    this.isFetchingOlder = false,
  });

  DiscoberyControllerState copyWith({
    bool? isLoading,
    bool? canFetchMore,
    bool? isFetchingOlder,
  }) {
    return DiscoberyControllerState(
      isFetchingOlder: isFetchingOlder ?? this.isFetchingOlder,
      isLoading: isLoading ?? this.isLoading,
      canFetchMore: canFetchMore ?? this.canFetchMore,
    );
  }
}
