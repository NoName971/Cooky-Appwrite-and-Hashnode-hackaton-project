import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackaton_v1/common/custom_list_tile.dart';
import 'package:hackaton_v1/common/network_image_widget.dart';
import 'package:hackaton_v1/common/text_style.dart';
import 'package:hackaton_v1/helpers/extensions.dart';
import 'package:hackaton_v1/features/discovery/views/recipe_view.dart';
import 'package:hackaton_v1/models/recipe_model.dart';

class MealCardHorizontal extends ConsumerStatefulWidget {
  const MealCardHorizontal({
    required this.textTheme,
    required this.recipe,
    this.onDelete,
    required this.buttons,
    super.key,
  });

  final TextTheme textTheme;
  final RecipeModel recipe;
  final void Function()? onDelete;
  final Widget buttons;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MealCardHorizontalState();
}

class _MealCardHorizontalState extends ConsumerState<MealCardHorizontal> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.push(
            context,
            RecipeView(
              recipeId: widget.recipe.id,
            ).route(),
          );
        },
        child: Column(
          children: [
            Row(
              children: [
                NetworkImageWidget(
                  imageId: widget.recipe.illustrationPic,
                  height: 100,
                  width: 120,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: CustomListTile(
                    title: Text(
                      widget.recipe.title,
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
                        Text(widget.recipe.cookingTime),
                        const SizedBox(
                          width: 32,
                        ),
                        Text('${widget.recipe.ingredients.length} ingredients'),
                        const SizedBox(
                          width: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            widget.buttons
          ],
        )).addFullPading(16);
  }
}
