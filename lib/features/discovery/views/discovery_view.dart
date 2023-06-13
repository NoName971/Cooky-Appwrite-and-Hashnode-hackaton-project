import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackaton_v1/common/custom_button.dart';
import 'package:hackaton_v1/common/logo_widget.dart';
import 'package:hackaton_v1/controllers/discovery_controller.dart';
import 'package:hackaton_v1/features/discovery/views/recipe_view.dart';
import 'package:hackaton_v1/features/discovery/widgets/meal_card_large.dart';
import 'package:hackaton_v1/models/recipe_model.dart';
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
    final discoveryController = ref.watch(discoveryProvider);
    final isLoading = ref.watch(discoveryProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        title: const LogoSmallWidget(),
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
          notificationPredicate: !isLoading ? (_) => true : (_) => false,
          onRefresh: () async {
            ref.read(discoveryProvider.notifier).getRecipes(
              ref: ref,
              fetchMode: FetchMode.normal,
              context: context,
              queries: [
                Query.orderDesc('\$createdAt'),
                Query.limit(10),
              ],
            );
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
                    Query.limit(10),
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
                            recipe: recipe,
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
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 16,
                      ),
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
                              Query.limit(10),
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
