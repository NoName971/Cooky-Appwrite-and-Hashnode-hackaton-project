import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:hackaton_v1/common/custom_button.dart';
import 'package:hackaton_v1/features/my_recipes/widgets/statistics_modal_widget.dart';
import 'package:hackaton_v1/helpers/utils.dart';
import 'package:hackaton_v1/controllers/my_recipes_controller.dart';
import 'package:hackaton_v1/features/my_recipes/views/edit_recipe.dart';
import 'package:hackaton_v1/models/recipe_model.dart';
import '../widgets/meal_card_horizontal.dart';
import '../widgets/recipe_deletion_confirmation.dart';

final favoritesRecipesProvider =
    StateProvider.autoDispose<List<RecipeModel>>((ref) => []);
final userRecipesProvider =
    StateProvider.autoDispose<List<RecipeModel>>((ref) => []);

class MyRecipes extends ConsumerStatefulWidget {
  const MyRecipes({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyRecipesState();
}

class _MyRecipesState extends ConsumerState<MyRecipes> {
  void deleteFavorite(recipeId) {
    Navigator.pop(context);
    ref.read(myRecipesProvider.notifier).removeFavorite(
          recipeId: recipeId,
          context: context,
        );
  }

  void deleteRecipe(recipeId) {
    Navigator.pop(context);
    ref.read(myRecipesProvider.notifier).deleteRecipe(
          recipeId: recipeId,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final favoritesRecipes = ref.watch(favoritesRecipesProvider);
    final userRecipes = ref.watch(userRecipesProvider);
    final isLoading = ref.watch(myRecipesProvider);
    final textTheme = Theme.of(context).textTheme;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('My recipes'),
          actions: [
            Visibility(
              visible: isLoading,
              child: Container(
                height: 24,
                width: 24,
                margin: const EdgeInsets.only(right: 16),
                child: const CircularProgressIndicator(),
              ),
            ),
          ],
          bottom: const PreferredSize(
            preferredSize: Size(double.infinity, kToolbarHeight),
            child: TabBar(
              tabs: [
                Tab(
                  text: 'Submitted',
                ),
                Tab(
                  text: 'Saved',
                ),
              ],
            ),
          ),
        ),
        body: FocusDetector(
            onVisibilityGained: () async {
              if (!isLoading) {
                await getUserRecipes(context);
              }
            },
            child: TabBarView(children: [
              RefreshIndicator(
                notificationPredicate: !isLoading ? (_) => true : (_) => false,
                onRefresh: () async {
                  if (!isLoading) {
                    getUserRecipes(context);
                  }
                },
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final userRecipe = userRecipes[index];
                          return IgnorePointer(
                            ignoring: isLoading,
                            child: MealCardHorizontal(
                              buttons: Row(
                                children: [
                                  Expanded(
                                    child: CustomButton(
                                      buttonType: ButtonType.outlined,
                                      buttonSize: ButtonSize.medium,
                                      child: const FittedBox(
                                        child: Text('Stats'),
                                      ),
                                      onPressed: () {
                                        showCustomModalBottomSheet(
                                          context,
                                          StatisticsModalWidget(
                                              userRecipe: userRecipe),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: CustomButton(
                                      buttonType: ButtonType.outlined,
                                      buttonSize: ButtonSize.medium,
                                      child: const FittedBox(
                                        child: Text('Edit'),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          EditRecipe.route(userRecipe),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: CustomButton(
                                      buttonType: ButtonType.filled,
                                      buttonSize: ButtonSize.medium,
                                      child: const FittedBox(
                                        child: Text('Delete'),
                                      ),
                                      onPressed: () async {
                                        return showCustomModalBottomSheet(
                                          context,
                                          RecipeDeletionConfirmationModal(
                                            onDelete: () =>
                                                deleteRecipe(userRecipe.id),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              textTheme: textTheme,
                              recipe: userRecipe,
                            ),
                          );
                        },
                        childCount: userRecipes.length,
                      ),
                    )
                  ],
                ),
              ),
              RefreshIndicator(
                notificationPredicate: !isLoading ? (_) => true : (_) => false,
                onRefresh: () async {
                  if (!isLoading) {
                    ref
                        .read(myRecipesProvider.notifier)
                        .getUserRecipes(context: context);
                  }
                },
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final favoriteRecipe = favoritesRecipes[index];
                          return MealCardHorizontal(
                            buttons: SizedBox(
                              width: double.infinity,
                              child: CustomButton(
                                buttonType: ButtonType.filled,
                                buttonSize: ButtonSize.medium,
                                child: const Text('Delete recipe'),
                                onPressed: () async {
                                  return showCustomModalBottomSheet(
                                    context,
                                    RecipeDeletionConfirmationModal(
                                      onDelete: () =>
                                          deleteFavorite(favoriteRecipe.id),
                                    ),
                                  );
                                },
                              ),
                            ),
                            textTheme: textTheme,
                            recipe: favoriteRecipe,
                          );
                        },
                        childCount: favoritesRecipes.length,
                      ),
                    )
                  ],
                ),
              ),
            ])),
      ),
    );
  }

  Future<void> getUserRecipes(BuildContext context) async {
    await ref.read(myRecipesProvider.notifier).getUserRecipes(context: context);
  }
}
