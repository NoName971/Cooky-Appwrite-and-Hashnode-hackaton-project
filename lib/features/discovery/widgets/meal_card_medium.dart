import 'package:flutter/material.dart';
import 'package:hackaton_v1/common/custom_list_tile.dart';

import 'package:hackaton_v1/common/network_image_widget.dart';
import 'package:hackaton_v1/common/text_style.dart';

class MealCardMedium extends StatelessWidget {
  const MealCardMedium({
    Key? key,
    required this.textTheme,
    required this.colorScheme,
    required this.title,
    required this.imageId,
    // required this.createdAt,
  }) : super(key: key);

  final TextTheme textTheme;
  final ColorScheme colorScheme;
  final String title;
  final String imageId;
  // final String createdAt;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            clipBehavior: Clip.antiAlias,
            child: NetworkImageWidget(
              imageId: imageId,
              height: 150,
              width: double.infinity,
            ),
          ),
          CustomListTile(
            title: Text(
              title,
              style: context.h5.copyWith(),
            ),
          )
        ],
      ),
    );
  }
}
