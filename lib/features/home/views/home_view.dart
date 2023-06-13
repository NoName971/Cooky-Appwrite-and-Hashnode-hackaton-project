import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackaton_v1/constants/ui_constants.dart';

import 'package:hackaton_v1/features/create_recipe/views/recipe_creation_view.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';
import '../../../common/custom_image_icon.dart';
import '../../../gen/assets.gen.dart';

final indexProvider = StateProvider.autoDispose((ref) => 0);

class HomeView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const HomeView());
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final index = ref.watch(indexProvider);
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      floatingActionButton: Visibility(
        visible: index != 1,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, RecipeCreationView.route());
          },
          child: CustomImageIcon(
            iconPath: Assets.icons.add.path,
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) {
          ref.watch(indexProvider.notifier).update((state) => value);
        },
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        indicatorColor: colorScheme.primaryContainer,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        destinations: [
          NavigationDestination(
            icon: CustomImageIcon(
              color: index == 0 ? Colors.white : colorScheme.onBackground,
              iconPath: index == 0
                  ? Assets.icons.homeFilled.path
                  : Assets.icons.home.path,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: CustomImageIcon(
              color: index == 1 ? Colors.white : colorScheme.onBackground,
              iconPath: Assets.icons.search.path,
            ),
            label: 'Search',
          ),
          NavigationDestination(
            icon: CustomImageIcon(
              color: index == 2 ? Colors.white : colorScheme.onBackground,
              iconPath: index == 2
                  ? Assets.icons.favoriteFilled.path
                  : Assets.icons.favorite.path,
            ),
            label: 'My recipes',
          ),
          NavigationDestination(
            icon: CustomImageIcon(
              color: index == 3 ? Colors.white : colorScheme.onBackground,
              iconPath: index == 3
                  ? Assets.icons.settings.path
                  : Assets.icons.settings.path,
            ),
            label: 'Profile',
          ),
        ],
      ),
      body: LazyLoadIndexedStack(
        index: index,
        children: UiConstants.bottomNavigationPages,
      ),
    );
  }
}
