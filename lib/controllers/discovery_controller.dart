import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackaton_v1/constants/ui_messages.dart';
import 'package:hackaton_v1/features/discovery/views/discovery_view.dart';
import 'package:hackaton_v1/features/discovery/views/recipe_view.dart';
import 'package:hackaton_v1/models/recipe_model.dart';
import 'package:hackaton_v1/services/auth_service.dart';
import 'package:hackaton_v1/services/recipe_service.dart';
import 'package:hackaton_v1/services/user_service.dart';
import '../helpers/utils.dart';
import '../models/failure.dart';
import '../models/like.dart';

final discoveryControllerProvider =
    StateNotifierProvider<DiscoveryViewController, DiscoberyControllerState>(
        (ref) {
  final recipeService = ref.watch(recipeServiceProvider);
  final userService = ref.watch(userServiceProvider);

  return DiscoveryViewController(
    userService: userService,
    recipeService: recipeService,
    ref: ref,
  );
});

final currentRecipeProvider = FutureProvider.autoDispose
    .family<({Failure? failure, RecipeModel? recipe}), String>(
  (ref, recipeId) async {
    final authService = ref.watch(authServiceProvider);
    final favorites = await ref.read(userServiceProvider).getFavorites();

    final like =
        await ref.read(userServiceProvider).getLike(recipeId: recipeId);
    if (like.isNotEmpty) {
      ref.read(likeProvider.notifier).update(
            (state) => Like.fromMap(like.first.data).id,
          );
      ref.read(isLikedProvider.notifier).update((state) => true);
    }
    ref.watch(favoritesIdsProvider.notifier).update((state) => [...favorites]);

    final recipeService = ref.watch(recipeServiceProvider);
    final recipe = await recipeService.getRecipe(recipeId: recipeId);
    final currentUserId = (await authService.getCurrentUser())!.$id;

    /* update views if it's not the creator who is currently viewing
     helpful if in the future stats are importants so the user himself cannot boost his stats by viewing
     his recipes himself
     */

    if (currentUserId != recipe.recipe!.uid) {
      await recipeService.updateRecipe(
        recipeId: recipeId,
        data: {"views": recipe.recipe!.views + 1},
      );
    }

    return recipe;
  },
);

class DiscoveryViewController extends StateNotifier<DiscoberyControllerState> {
  final RecipeService _recipeService;
  final UserService _userService;
  final Ref _ref;

  DiscoveryViewController({
    required RecipeService recipeService,
    required UserService userService,
    required Ref ref,
  })  : _recipeService = recipeService,
        _userService = userService,
        _ref = ref,
        super(
          const DiscoberyControllerState(),
        );

  Future<void> getRecipes({
    required BuildContext context,
    required List<String> queries,
    required FetchMode fetchMode,
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
      final topRecipes = await _recipeService.getRecipes(queries: [
        Query.orderDesc('likes'),
        Query.limit(5),
      ]);
      if (topRecipes.recipes!.documents.isNotEmpty) {
        _ref.read(topRecipesProvider.notifier).update(
          (state) {
            return [
              ...topRecipes.recipes!.documents
                  .map((e) => RecipeModel.fromMap(e.data))
                  .toList()
            ];
          },
        );
      }

      if (response.failure != null) {
        state = state.copyWith(
          isLoading: false,
        );
        if (context.mounted) {
          showSnackBar(context, UiMessages.unexpectedError);
        }
      } else {
        if (fetchMode == FetchMode.normal) {
          List<RecipeModel> newRecipes = [];
          for (final recipe in response.recipes!.documents) {
            newRecipes.add(RecipeModel.fromMap(recipe.data));
          }
          state = state.copyWith(
            isLoading: false,
            canFetchMore: true,
          );
          _ref.read(recipesProvider.notifier).update((state) {
            return [...newRecipes];
          });
        }
        //  else if (fetchMode == FetchMode.newer) {
        //   List<RecipeModel> newRecipes = [];
        //   final oldRecipes = ref.watch(recipesProvider);
        //   for (final recipe in response.recipes!.documents) {
        //     newRecipes.add(RecipeModel.fromMap(recipe.data));
        //   }
        //   state = state.copyWith(isLoading: false);
        //   _ref.read(recipesProvider.notifier).update((state) {
        //     return [...newRecipes, ...oldRecipes];
        //   });
        // }
        else if (fetchMode == FetchMode.older) {
          List<RecipeModel> newRecipes = [];
          final oldRecipes = _ref.read(recipesProvider);
          for (final recipe in response.recipes!.documents) {
            newRecipes.add(RecipeModel.fromMap(recipe.data));
          }

          _ref.read(recipesProvider.notifier).update((state) {
            return [...oldRecipes, ...newRecipes];
          });
          state = state.copyWith(
            canFetchMore: newRecipes.length < 10 ? false : true,
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
      showSnackBar(context, UiMessages.unexpectedError);
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
        final like =
            await _recipeService.updateRecipe(recipeId: recipeId, data: {
          'likes': response.recipe!.likes + 1,
        });
        if (like.hasSucceded) {
          _ref.read(likeProvider.notifier).update((state) => likeId);
          _ref.read(isLikedProvider.notifier).update((state) => !state);
        } else {
          if (context.mounted) {
            showSnackBar(
              context,
              response.failure?.message ?? UiMessages.unexpectedError,
            );
          }
        }
      } else {
        if (context.mounted) {
          showSnackBar(
            context,
            response.failure?.message ?? UiMessages.unexpectedError,
          );
        }
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
      final response2 = await _userService.dbRemoveLike(likeId: likeId);

      if (response2.hasSucceded) {
        final removeLike = await _recipeService.updateRecipe(
          recipeId: recipeId,
          data: {
            'likes': response.recipe!.likes - 1,
          },
        );

        if (removeLike.hasSucceded) {
          _ref.read(isLikedProvider.notifier).update((state) => !state);
        } else {
          if (context.mounted) {
            showSnackBar(
              context,
              response.failure?.message ?? UiMessages.unexpectedError,
            );
          }
        }
      } else {
        if (context.mounted) {
          showSnackBar(
            context,
            response.failure?.message ?? UiMessages.unexpectedError,
          );
        }
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
