import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackaton_v1/common/custom_list_tile.dart';
import 'package:hackaton_v1/controllers/profile_controller.dart';
import '../../../common/appbar.dart';
import '../../../core/utils.dart';
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
      appBar: appBar(const Text('Profile')),
      body: CustomScrollView(
        slivers: [
          // SliverToBoxAdapter(
          //   child: Column(
          //     children: [
          //       Container(
          //         height: 90,
          //         width: 90,
          //         padding: const EdgeInsets.all(16),
          //         margin: const EdgeInsets.only(top: 16, bottom: 10),
          //         decoration: BoxDecoration(
          //           shape: BoxShape.circle,
          //           color: context.colorScheme.primary,
          //         ),
          //         child: Center(
          //           child: FittedBox(
          //             child: Text(
          //               'N N',
          //               style: context.h2.copyWith(
          //                 color: context.colorScheme.background,
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //       Text(
          //         'No Name Dev',
          //         style: context.h4,
          //       )
          //     ],
          //   ),
          // ),
          // const SliverToBoxAdapter(
          //   child: SizedBox(
          //     height: 20,
          //   ),
          // ),
          // const SliverToBoxAdapter(
          //   child: CustomListTile(
          //     contentPadding: EdgeInsets.fromLTRB(16, 16, 32, 0),
          //     title: Text('Edit profile'),
          //     trailing: Icon(Icons.edit),
          //   ),
          // ),
          SliverToBoxAdapter(
            child: CustomListTile(
              onTap: () {
                Navigator.push(context, PasswordChangeView.route());
              },
              contentPadding: const EdgeInsets.fromLTRB(16, 20, 32, 0),
              title: const Text('Update password'),
              trailing: const Icon(Icons.password),
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
