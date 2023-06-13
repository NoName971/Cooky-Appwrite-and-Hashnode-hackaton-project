import 'package:flutter/material.dart';
import 'package:hackaton_v1/common/custom_list_tile.dart';
import 'package:hackaton_v1/common/text_style.dart';
import 'package:hackaton_v1/models/recipe_model.dart';

class StatisticsModalWidget extends StatelessWidget {
  const StatisticsModalWidget({
    super.key,
    required this.userRecipe,
  });

  final RecipeModel userRecipe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: kBottomNavigationBarHeight,
      ),
      child: CustomListTile(
        title: Text(
          'Statistics',
          style: context.h4,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 10,
            ),
            Text('Views : ${userRecipe.views}'),
            Text('Likes : ${userRecipe.likes}'),
          ],
        ),
      ),
    );
  }
}
