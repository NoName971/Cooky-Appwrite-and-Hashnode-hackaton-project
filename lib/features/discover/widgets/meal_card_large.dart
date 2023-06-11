import 'package:flutter/material.dart';
import 'package:hackaton_v1/common/network_image_widget.dart';
import 'package:hackaton_v1/common/text_style.dart';
import 'package:hackaton_v1/helpers/extensions.dart';

import '../../../common/custom_image_icon.dart';
import '../../../common/custom_list_tile.dart';
import '../../../gen/assets.gen.dart';

class MealCardLargeWidget extends StatelessWidget {
  const MealCardLargeWidget({
    super.key,
    required this.title,
    required this.textTheme,
    required this.colorScheme,
    required this.imageId,
    required this.cookingTime,
    required this.likes,
  });

  final TextTheme textTheme;
  final ColorScheme colorScheme;
  final String title;
  final String imageId;
  final String cookingTime;
  final int likes;

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
            imageId: imageId,
            height: 250,
            width: double.infinity,
          ),
          // Positioned(
          //   left: 16,
          //   top: 16,
          //   child: Text(
          //     'Rice',
          //     style: textTheme.p3Medium.copyWith(color: Colors.white),
          //   ).frosted(
          //     blur: 15,
          //     frostColor: colorScheme.primary,
          //     borderRadius: BorderRadius.circular(10),
          //     padding: const EdgeInsets.all(8),
          //   ),
          // ),
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
                title,
                style: context.h3.copyWith(
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                cookingTime,
                style: context.p3Regular.copyWith(
                  color: Colors.white,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomImageIcon(
                    color: Colors.white,
                    iconPath: Assets.icons.starFilled.path,
                  ),
                  Text(
                    likes.toString(),
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
