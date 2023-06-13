import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackaton_v1/common/custom_list_tile.dart';
import 'package:hackaton_v1/common/text_style.dart';
import 'package:hackaton_v1/controllers/profile_controller.dart';
import 'package:hackaton_v1/features/profile/views/full_name_update.dart';
import 'package:hackaton_v1/helpers/extensions.dart';
import 'package:hackaton_v1/main.dart';
import 'package:hackaton_v1/models/user_model.dart';
import '../../../common/appbar.dart';
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
      appBar: appBar(const Text('Profile')),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ProfileWIdget(currentUser: currentUser),
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

class ProfileWIdget extends StatelessWidget {
  const ProfileWIdget({
    super.key,
    required this.currentUser,
  });

  final UserModel currentUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 90,
          width: 90,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(top: 16, bottom: 10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.colorScheme.primary,
          ),
          child: Center(
            child: FittedBox(
              child: Text(
                getInitials(currentUser.name),
                style: context.h2.copyWith(
                  color: context.colorScheme.background,
                ),
              ),
            ),
          ),
        ),
        Text(
          currentUser.name,
          style: context.h4,
        ),
        Text(
          currentUser.email,
        )
      ],
    );
  }
}
