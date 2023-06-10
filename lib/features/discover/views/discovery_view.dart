import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackaton_v1/common/custom_button.dart';
import 'package:hackaton_v1/controllers/discovery_controller.dart';
import 'package:hackaton_v1/features/discover/views/recipe_view.dart';
import 'package:hackaton_v1/features/discover/widgets/meal_card_large.dart';
import 'package:hackaton_v1/models/recipe_model.dart';
import '../../../common/custom_image_icon.dart';
import '../../../gen/assets.gen.dart';
import 'package:focus_detector/focus_detector.dart';

final recipesProvider = StateProvider.autoDispose<List<RecipeModel>>((ref) {
  return [];
});

class DiscoveryView extends ConsumerStatefulWidget {
  const DiscoveryView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DiscoveryViewState();
}

class _DiscoveryViewState extends ConsumerState<DiscoveryView> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      ref.read(discoveryProvider.notifier).getRecipes(
        ref: ref,
        fetchMode: FetchMode.normal,
        context: context,
        queries: [
          Query.orderDesc('\$createdAt'),
          Query.limit(10),
        ],
      );
    });

    super.initState();
  }

  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    final recipes = ref.watch(recipesProvider);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final discoveryController = ref.watch(discoveryProvider);
    final isLoading = ref.watch(discoveryProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        title: CustomImageIcon(iconPath: Assets.icons.hotPot.path),
        centerTitle: true,
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
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return RefreshIndicator(
          onRefresh: () async {
            // if (recipes.isEmpty) {
            await ref.read(discoveryProvider.notifier).getRecipes(
              ref: ref,
              fetchMode: FetchMode.normal,
              context: context,
              queries: [
                Query.orderDesc('\$createdAt'),
                Query.limit(5),
              ],
            );
            // } else {
            //   await ref.read(discoveryProvider.notifier).getRecipes(
            //     ref: ref,
            //     context: context,
            //     fetchMode: FetchMode.newer,
            //     queries: [
            //       Query.limit(5),
            //       Query.cursorBefore(recipes.first.id),
            //       Query.orderDesc('\$createdAt'),
            //     ],
            //   );
            // }
          },
          child: FocusDetector(
            onVisibilityGained: () async {
              if (!isLoading) {
                await ref.read(discoveryProvider.notifier).getRecipes(
                  ref: ref,
                  fetchMode: FetchMode.normal,
                  context: context,
                  queries: [
                    Query.orderDesc('\$createdAt'),
                    Query.limit(5),
                  ],
                );
              }
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final recipe = recipes[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              RecipeView(recipeId: recipe.id).route(),
                            );
                          },
                          child: MealCardLargeWidget(
                            cookingTime: recipe.cookingTime,
                            imageId: recipe.illustrationPic,
                            title: recipe.title,
                            likes: recipe.likes,
                            textTheme: textTheme,
                            colorScheme: colorScheme,
                          ),
                        ),
                      );
                    },
                    childCount: recipes.length,
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 16),
                ),
                SliverVisibility(
                  visible:
                      discoveryController.canFetchMore && recipes.length >= 10,
                  sliver: SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CustomButton(
                        buttonType: ButtonType.outlinedIcon,
                        buttonSize: ButtonSize.small,
                        icon: !discoveryController.isFetchingOlder
                            ? const Icon(Icons.add)
                            : const SizedBox(
                                height: 24,
                                width: 24,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                        child: const Text('Load more'),
                        onPressed: () {
                          ref.read(discoveryProvider.notifier).getRecipes(
                            ref: ref,
                            fetchMode: FetchMode.older,
                            context: context,
                            queries: [
                              Query.orderDesc('\$createdAt'),
                              Query.cursorAfter(
                                  ref.read(recipesProvider).last.id),
                              Query.limit(5),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
