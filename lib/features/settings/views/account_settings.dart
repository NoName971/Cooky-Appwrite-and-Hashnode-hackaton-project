import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackaton_v1/common/appbar.dart';
import 'package:hackaton_v1/common/custom_image_icon.dart';
import 'package:hackaton_v1/common/custom_list_tile.dart';
import 'package:hackaton_v1/common/text_style.dart';
import 'package:hackaton_v1/controllers/auth_controller.dart';
import 'package:hackaton_v1/controllers/settings_controller.dart';
import 'package:hackaton_v1/features/settings/views/full_name_update.dart';
import 'package:hackaton_v1/features/settings/views/password_update_view.dart';
import 'package:hackaton_v1/gen/assets.gen.dart';
import 'package:hackaton_v1/helpers/utils.dart';
import 'package:hackaton_v1/main.dart';

final isVerifiedProvider = StateProvider((ref) => false);

class ProfileSettings extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const ProfileSettings());
  const ProfileSettings({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfileSettingsState();
}

class _ProfileSettingsState extends ConsumerState<ProfileSettings> {
  Timer? timer;
  checkEmailVerificationStatus() async {
    final isVerified =
        (await ref.read(authControllerProvider.notifier).getCurrentUser())!
            .emailVerification;
    if (isVerified) {
      ref.read(globalCurrentUserProvider.notifier).update(
            (state) => state.copyWith(isVerified: true),
          );
      timer!.cancel();
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then(
      (value) async {
        final isVerified =
            (await ref.read(authControllerProvider.notifier).getCurrentUser())!
                .emailVerification;
        if (!isVerified) {
          timer = Timer.periodic(
            const Duration(seconds: 5),
            (timer) => checkEmailVerificationStatus(),
          );
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    if (timer != null) timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(globalCurrentUserProvider);
    ref.listen(authControllerProvider.select((value) => value),
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
      appBar: appBar(const Text('Account settings')),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 20,
            ),
          ),
          SliverToBoxAdapter(
            child: CustomListTile(
              contentPadding: const EdgeInsets.fromLTRB(16, 0, 32, 0),
              title: const Text('Account status'),
              trailing: Visibility(
                replacement: CustomImageIcon(
                  iconPath: Assets.icons.verifiedFILL1Wght400GRAD0Opsz48.path,
                ),
                visible: !currentUser.isVerified,
                child: CustomImageIcon(
                  iconPath:
                      Assets.icons.exclamationFILL1Wght400GRAD0Opsz48.path,
                ),
              ),
              subtitle: currentUser.isVerified
                  ? Text(
                      'Verified',
                      style: context.p2Medium,
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Unverified',
                          style: context.p2Medium,
                        ),
                        const Text(
                          'Tap to send verification email',
                        ),
                      ],
                    ),
              onTap: () {
                if (!currentUser.isVerified) {
                  ref
                      .read(settingsControllerProvider.notifier)
                      .sendAccountVerificationEmail(
                        email: currentUser.email,
                        context: context,
                      );
                }
              },
            ),
          ),
          SliverToBoxAdapter(
            child: CustomListTile(
              contentPadding: const EdgeInsets.fromLTRB(16, 0, 32, 0),
              title: const Text('Update password'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(context, PasswordChangeView.route());
              },
            ),
          ),
          SliverToBoxAdapter(
            child: CustomListTile(
              contentPadding: const EdgeInsets.fromLTRB(16, 0, 32, 0),
              title: const Text('Update full name'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(context, FullNameUpdate.route());
              },
            ),
          ),
        ],
      ),
    );
  }
}
