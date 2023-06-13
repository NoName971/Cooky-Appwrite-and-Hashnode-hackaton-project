import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackaton_v1/common/custom_list_tile.dart';
import 'package:hackaton_v1/controllers/profile_controller.dart';
import 'package:hackaton_v1/features/profile/views/full_name_update.dart';
import 'package:hackaton_v1/features/profile/widgets/profile_widget.dart';
import 'package:hackaton_v1/main.dart';
import '../../../helpers/utils.dart';
import '../../../gen/assets.gen.dart';
import '../../../services/dark_mode_service.dart';
import 'password_update_view.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(darkModeProvider);
    final currentUser = ref.watch(globalCurrentUserProvider);
    ref.listen(profileProvider.select((value) => value), (previous, next) {
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
          SliverToBoxAdapter(
            child: CustomListTile(
              contentPadding: const EdgeInsets.fromLTRB(16, 16, 32, 0),
              title: const Text('Update name'),
              trailing: const Icon(Icons.edit),
              onTap: () {
                Navigator.push(context, FullNameUpdate.route());
              },
            ),
          ),
          SliverToBoxAdapter(
            child: CustomListTile(
              onTap: () {
                Navigator.push(context, PasswordChangeView.route());
              },
              contentPadding: const EdgeInsets.fromLTRB(16, 0, 32, 0),
              title: const Text('Update password'),
              trailing: const Icon(Icons.edit),
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
                    .read(profileProvider.notifier)
                    .logout(context: context);
                ref.invalidate(globalCurrentUserProvider);
              },
              contentPadding: const EdgeInsets.fromLTRB(16, 0, 32, 16),
              title: const Text('Logout'),
              trailing: const Icon(Icons.logout),
            ),
          )
        ],
      ),
    );
  }
}
