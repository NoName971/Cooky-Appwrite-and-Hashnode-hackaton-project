import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackaton_v1/common/custom_list_tile.dart';
import 'package:hackaton_v1/controllers/settings_controller.dart';
import 'package:hackaton_v1/features/settings/views/account_settings.dart';
import 'package:hackaton_v1/features/settings/widgets/profile_widget.dart';
import 'package:hackaton_v1/main.dart';
import '../../../helpers/utils.dart';
import '../../../gen/assets.gen.dart';
import '../../../services/dark_mode_service.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(darkModeProvider);
    final currentUser = ref.watch(globalCurrentUserProvider);
    ref.listen(settingsControllerProvider.select((value) => value),
        (previous, next) {
      if (next) {
        showLoadingIndicator(
          context: context,
        );
      } else if (!next) {
        Navigator.pop(context);
      }
    });
    return Scaffold(
      appBar: AppBar(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ProfileWidget(currentUser: currentUser),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 20,
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 16,
            ),
          ),
          SliverToBoxAdapter(
            child: CustomListTile(
              contentPadding: const EdgeInsets.fromLTRB(16, 0, 32, 0),
              title: const Text('Account settings'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(context, ProfileSettings.route());
              },
            ),
          ),
          SliverToBoxAdapter(
            child: CustomListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              title: const Text('Dark mode'),
              trailing: Switch.adaptive(
                inactiveThumbImage: AssetImage(Assets.icons.lightMode.path),
                activeThumbImage: AssetImage(Assets.icons.darkMode.path),
                value: isDarkMode,
                onChanged: (_) {
                  ref.read(darkModeProvider.notifier).switchTheme();
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: CustomListTile(
              onTap: () async {
                await ref
                    .read(settingsControllerProvider.notifier)
                    .logout(context: context);
              },
              contentPadding: const EdgeInsets.only(
                left: 16,
                right: 32,
              ),
              title: const Text('Logout'),
              trailing: const Icon(Icons.logout),
            ),
          )
        ],
      ),
    );
  }
}
