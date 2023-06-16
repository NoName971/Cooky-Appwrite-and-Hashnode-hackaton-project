import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackaton_v1/constants/ui_messages.dart';
import 'package:hackaton_v1/helpers/utils.dart';
import 'package:hackaton_v1/features/search/views/search_view.dart';
import 'package:hackaton_v1/models/recipe_model.dart';
import 'package:hackaton_v1/services/recipe_service.dart';

final searchControllerProvider = StateNotifierProvider<SearchController, bool>(
  (ref) {
    final recipeService = ref.watch(recipeServiceProvider);
    return SearchController(
      recipeService: recipeService,
      ref: ref,
    );
  },
);

class SearchController extends StateNotifier<bool> {
  final RecipeService _recipeService;
  final Ref _ref;

  SearchController({
    required RecipeService recipeService,
    required Ref ref,
  })  : _recipeService = recipeService,
        _ref = ref,
        super(false);

  Future<void> searchRecipes({
    required String query,
    required BuildContext context,
  }) async {
    state = !state;
    final List<RecipeModel> recipes = [];
    final response = await _recipeService.getRecipes(
      queries: [
        Query.search(
          'queryableString',
          query,
        ),
      ],
    );
    state = !state;
    if (response.failure != null) {
      if (context.mounted) {
        showSnackBar(
          context,
          response.failure?.message ?? UiMessages.unexpectedError,
        );
      }
    } else {
      for (final recipe in response.recipes?.documents ?? []) {
        recipes.add(RecipeModel.fromMap(recipe.data));
      }
      if (!_ref.read(searchedOnceProvider)) {
        _ref.read(searchedOnceProvider.notifier).update((state) => true);
      }
      _ref.read(searchResultsProvider.notifier).update((state) => [...recipes]);
    }
  }
}
