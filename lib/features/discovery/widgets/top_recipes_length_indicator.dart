import 'package:flutter/material.dart';
import 'package:hackaton_v1/common/text_style.dart';
import 'package:hackaton_v1/models/recipe_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class TopRecipesLengthIndicator extends StatelessWidget {
  const TopRecipesLengthIndicator({
    super.key,
    required this.pageController,
    required this.topRecipes,
  });

  final PageController pageController;
  final List<RecipeModel> topRecipes;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: SmoothPageIndicator(
        controller: pageController, // PageController
        count: topRecipes.length,
        effect: WormEffect(
          dotHeight: 8,
          dotWidth: 8,
          activeDotColor: context.colorScheme.secondary,
        ),
        onDotClicked: (index) {},
      ),
    );
  }
}
