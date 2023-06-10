import 'package:hackaton_v1/features/discover/views/discovery_view.dart';
import 'package:hackaton_v1/features/my_recipes/views/my_recipes.dart';
import 'package:hackaton_v1/features/profile/views/profile_view.dart';
import 'package:hackaton_v1/features/search/views/search_view.dart';

class UiConstants {
  static const bottomNavigationPages = [
    DiscoveryView(),
    SearchView(),
    MyRecipes(),
    ProfileView(),
  ];
}
