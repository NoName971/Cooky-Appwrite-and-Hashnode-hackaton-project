import 'package:hackaton_v1/features/discover/views/discovery_view.dart';
import 'package:hackaton_v1/features/favorite/views/favorite_view.dart';
import 'package:hackaton_v1/features/profile/views/profile_view.dart';
import 'package:hackaton_v1/features/search/views/search_view.dart';

class UiConstants {
  static const bottomNavigationPages = [
    DiscoverView(),
    SearchView(),
    FavoriteView(),
    ProfileView(),
  ];
}
