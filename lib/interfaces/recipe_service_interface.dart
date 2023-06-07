import 'package:hackaton_v1/models/failure.dart';
import 'package:appwrite/models.dart' as model;
import 'package:hackaton_v1/models/recipe_model.dart';

abstract class IRecipeService {
  Future<({Failure? failure, model.DocumentList? recipes})> getRecipes({
    required List<String> queries,
  });
  // Future<({Failure? failure, model.Document? recipe})> getRecipe({
  //   required String recipeId,
  // });
  Future<({RecipeModel? recipe, Failure? failure})> getRecipe({
    required String recipeId,
  });

  Future<({Failure? failure, model.Document? document})> createRecipe({
    required RecipeModel recipeModel,
  });
  Future<({Failure? failure, String? response})> deleteRecipe({
    required String recipeId,
  });
}
