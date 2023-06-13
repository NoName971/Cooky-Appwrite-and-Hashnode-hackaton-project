import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackaton_v1/common/custom_image_icon.dart';
import 'package:hackaton_v1/common/custom_list_tile.dart';
import 'package:hackaton_v1/common/error_view.dart';
import 'package:hackaton_v1/common/network_image_widget.dart';
import 'package:hackaton_v1/common/text_style.dart';
import 'package:hackaton_v1/helpers/extensions.dart';
import 'package:hackaton_v1/features/create_recipe/views/image_preview.dart';
import 'package:hackaton_v1/controllers/discovery_controller.dart';
import 'package:hackaton_v1/gen/assets.gen.dart';
import 'package:hackaton_v1/helpers/utils.dart';

final attachmentNameProvider = StateProvider.autoDispose<List>((ref) {
  return [];
});

final likeProvider = StateProvider.autoDispose((ref) => '');

final isLikedProvider = StateProvider.autoDispose((ref) => false);

final favoritesIdsProvider = StateProvider.autoDispose((ref) {
  return [];
});

class RecipeView extends ConsumerStatefulWidget {
  route() => MaterialPageRoute(
        builder: (context) => RecipeView(
          recipeId: recipeId,
        ),
      );
  const RecipeView({
    required this.recipeId,
    super.key,
  });

  final String recipeId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RecipeViewState();
}

class _RecipeViewState extends ConsumerState<RecipeView> {
  @override
  Widget build(BuildContext context) {
    final future = ref.watch(
      currentRecipeProvider(widget.recipeId),
    );
    final isLiked = ref.watch(isLikedProvider);
    final like = ref.watch(likeProvider);
    final favorites = ref.watch(favoritesIdsProvider);
    bool isFavorite = favorites.contains(widget.recipeId);

    return RefreshIndicator(
      onRefresh: () async {
        return ref.invalidate(
          currentRecipeProvider(widget.recipeId),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IgnorePointer(
              ignoring: future.isLoading,
              child: IconButton(
                onPressed: () {
                  if (favorites.contains(widget.recipeId)) {
                    ref.read(discoveryProvider.notifier).removeFavorite(
                          recipeId: widget.recipeId,
                          ref: ref,
                          context: context,
                        );
                  } else {
                    ref.read(discoveryProvider.notifier).addFavorite(
                          recipeId: widget.recipeId,
                          ref: ref,
                          context: context,
                        );
                  }
                },
                icon: CustomImageIcon(
                  iconPath: isFavorite
                      ? Assets.icons.favoriteFilled.path
                      : Assets.icons.favorite.path,
                ),
              ),
            ),
            IgnorePointer(
              ignoring: future.isLoading,
              child: IconButton(
                onPressed: () {
                  if (isLiked) {
                    ref.read(discoveryProvider.notifier).removeLike(
                          recipeId: widget.recipeId,
                          context: context,
                          ref: ref,
                          likeId: like,
                        );
                  } else {
                    ref.read(discoveryProvider.notifier).like(
                          recipeId: widget.recipeId,
                          context: context,
                          ref: ref,
                        );
                  }
                },
                icon: CustomImageIcon(
                  iconPath: isLiked
                      ? Assets.icons.starFilled.path
                      : Assets.icons.star.path,
                ),
              ),
            )
          ],
        ),
        body: future.when(
          data: (data) {
            if (data.recipe != null) {
              final recipe = data.recipe!;
              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ImagePreviewView(
                              imagePath: recipe.illustrationPic,
                            ),
                          ),
                        );
                      },
                      child: NetworkImageWidget(
                        imageId: recipe.illustrationPic,
                        height: 250,
                        width: double.infinity,
                      ),
                    ).addHorizontalPadding(16),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 8,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: CustomListTile(
                      title: Text(
                        recipe.title,
                        style: context.h2,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  style: TextStyle(
                                    fontFamily: 'DMSans',
                                    color: context.colorScheme.onBackground,
                                  ),
                                  text: 'By',
                                ),
                                TextSpan(
                                  text: ' ${recipe.userName}',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                    color: context.colorScheme.onBackground,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            recipe.createdAt!.readableDateFormat(),
                            style: context.p3Regular,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              CustomImageIcon(
                                iconPath: Assets.icons.schedule.path,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(recipe.cookingTime),
                              const SizedBox(
                                width: 32,
                              ),
                              CustomImageIcon(
                                iconPath: Assets.icons.nutrition.path,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text('${recipe.ingredients.length} ingredients'),
                              const SizedBox(
                                width: 16,
                              ),
                            ],
                          )
                        ],
                      ),
                    ).addHorizontalPadding(16),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 24,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Text(
                      'Ingredients',
                      style: context.h4,
                    ).addHorizontalPadding(16),
                  ),
                  SliverToBoxAdapter(
                    child: Wrap(
                      spacing: 10,
                      children: recipe.ingredients
                          .map((ingredient) => Chip(label: Text(ingredient)))
                          .toList(),
                    ).addFullPading(16),
                  ),
                  const SliverToBoxAdapter(
                      child: SizedBox(
                    height: 20,
                  )),
                  SliverToBoxAdapter(
                    child: Text(
                      'Instructions',
                      style: context.h4,
                    ).addHorizontalPadding(16),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final instruction = recipe.cookingSteps[index];
                        final attachments = recipe.cookingStepsPics;
                        final attachment = attachments[index];
                        // final attachment = attachments
                        //     .firstWhereOrNull((e) => e.startsWith('${index}_'));
                        return CustomListTile(
                          title: Row(
                            children: [
                              const Text('Step'),
                              const SizedBox(
                                width: 10,
                              ),
                              CircleAvatar(
                                radius: 13,
                                child: Text(
                                  '${index + 1}',
                                  style: context.p3Medium,
                                ),
                              )
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Visibility(
                                visible: attachment.isNotEmpty,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ImagePreviewView(
                                            imagePath: attachment),
                                      ),
                                    );
                                  },
                                  child: NetworkImageWidget(
                                    imageId: attachment,
                                    height: 200,
                                    width: double.infinity,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(instruction),
                            ],
                          ),
                        ).addFullPading(16);
                      },
                      childCount: recipe.cookingSteps.length,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).viewPadding.bottom,
                    ),
                  )
                ],
              );
            }
            return const SizedBox.shrink();
          },
          error: (error, stackTrace) {
            return ErrorView(
              provider: currentRecipeProvider(widget.recipeId),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
