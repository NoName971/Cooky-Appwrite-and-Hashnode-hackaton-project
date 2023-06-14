import 'package:flutter/material.dart';
import 'package:hackaton_v1/common/network_image_widget.dart';
import 'package:hackaton_v1/common/text_style.dart';
import 'package:hackaton_v1/helpers/extensions.dart';
import 'package:hackaton_v1/helpers/utils.dart';
import 'package:hackaton_v1/models/recipe_model.dart';

import '../../../common/custom_image_icon.dart';
import '../../../common/custom_list_tile.dart';
import '../../../gen/assets.gen.dart';

class MealCardLargeWidget extends StatelessWidget {
  const MealCardLargeWidget({
    super.key,
    required this.recipe,
  });

  final RecipeModel recipe;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      clipBehavior: Clip.antiAlias,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          NetworkImageWidget(
            imageId: recipe.illustrationPic,
            height: 250,
            width: double.infinity,
          ),
          Container(
            alignment: Alignment.bottomLeft,
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(
                  Assets.images.darkOverlay.path,
                ),
              ),
            ),
            child: CustomListTile(
              contentPadding: const EdgeInsets.only(left: 16),
              title: Text(
                recipe.title,
                style: context.h3.copyWith(
                  color: Colors.white,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    recipe.createdAt!.readableDateFormat(),
                    style: context.p3Regular.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    recipe.cookingTime,
                    style: context.p3Regular.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomImageIcon(
                    color: Colors.white,
                    iconPath: Assets.icons.favoriteFilled.path,
                  ),
                  Text(
                    recipe.likes.toString(),
                    style: context.p2Medium.copyWith(
                      color: Colors.white,
                    ),
                  )
                ],
              ).addHorizontalPadding(16),
            ),
          ),
        ],
      ),
    );
  }
}
