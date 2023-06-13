import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:hackaton_v1/common/custom_textfield.dart';
import 'package:hackaton_v1/common/text_style.dart';
import 'package:hackaton_v1/helpers/extensions.dart';
import 'package:hackaton_v1/controllers/search_controller.dart';
import 'package:hackaton_v1/models/recipe_model.dart';
import '../../../common/appbar.dart';
import '../../../common/custom_list_tile.dart';
import '../../../common/network_image_widget.dart';
import '../../../helpers/utils.dart';
import '../../discovery/views/recipe_view.dart';

final searchResultsProvider =
    StateProvider.autoDispose<List<RecipeModel>>((ref) {
  return [];
});

final searchedOnceProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});

class SearchView extends ConsumerStatefulWidget {
  const SearchView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {
  TextEditingController textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final searchedOnce = ref.watch(searchedOnceProvider);
    final searchResults = ref.watch(searchResultsProvider);

    ref.listen(searchProvider.select((value) => value), (previous, next) {
      if (next) {
        showLoadingIndicator(
          context: context,
        );
      } else if (!next) {
        Navigator.pop(context);
      }
    });

    return Scaffold(
      appBar: appBar(
        const Text('Search'),
        true,
      ),
      body: FocusDetector(
        onVisibilityLost: () {
          FocusScope.of(context).unfocus();
        },
        child: Form(
          key: _formKey,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: CustomTextField(
                  validator: (value) {
                    if (value == null || value.trim().length < 3) {
                      return '3 characters minimum';
                    }
                    return null;
                  },
                  controller: textEditingController,
                  suffixIcon: IconButton(
                    onPressed: () async {
                      final validation = _formKey.currentState!.validate();
                      if (validation) {
                        FocusScope.of(context).unfocus();
                        ref.read(searchProvider.notifier).searchRecipes(
                              query: textEditingController.text,
                              context: context,
                            );
                      }
                    },
                    icon: const Icon(Icons.search),
                  ),
                ).addHorizontalPadding(16),
              ),
              SliverVisibility(
                visible: searchedOnce,
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'Results (${searchResults.length})',
                    style: context.h4,
                  ).addFullPading(16),
                ),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                      childCount: searchResults.length, (context, index) {
                final recipe = searchResults[index];
                return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.push(
                        context,
                        RecipeView(
                          recipeId: recipe.id,
                        ).route(),
                      );
                    },
                    child: Row(
                      children: [
                        NetworkImageWidget(
                          imageId: recipe.illustrationPic,
                          height: 100,
                          width: 120,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: CustomListTile(
                            title: Text(
                              recipe.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: context.h5.copyWith(),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(recipe.cookingTime),
                                const SizedBox(
                                  width: 32,
                                ),
                                Text(
                                    '${recipe.ingredients.length} ingredients'),
                                const SizedBox(
                                  width: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )).addSymetricPadding(
                  horizontal: 16,
                  vertical: 16,
                );
              }))
            ],
          ),
        ),
      ),
    );
  }
}
