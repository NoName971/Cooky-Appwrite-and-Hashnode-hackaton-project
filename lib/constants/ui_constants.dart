import 'package:hackaton_v1/features/discovery/views/discovery_view.dart';
import 'package:hackaton_v1/features/my_recipes/views/my_recipes.dart';
import 'package:hackaton_v1/features/settings/views/settings_view.dart';
import 'package:hackaton_v1/features/search/views/search_view.dart';

class UiConstants {
  static const bottomNavigationPages = [
    DiscoveryView(),
    SearchView(),
    MyRecipes(),
    SettingsView(),
  ];
}
