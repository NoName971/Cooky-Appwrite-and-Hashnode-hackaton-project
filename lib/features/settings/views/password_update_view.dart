import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackaton_v1/common/appbar.dart';
import 'package:hackaton_v1/common/custom_image_icon.dart';
import 'package:hackaton_v1/common/custom_textfield.dart';
import 'package:hackaton_v1/gen/assets.gen.dart';
import 'package:hackaton_v1/helpers/extensions.dart';
import 'package:hackaton_v1/features/create_recipe/widgets/textfield_label_widget.dart';
import 'package:hackaton_v1/controllers/settings_controller.dart';

import '../../../common/custom_button.dart';
import '../../../helpers/utils.dart';

class PasswordChangeView extends ConsumerStatefulWidget {
  static route() =>
      MaterialPageRoute(builder: ((context) => const PasswordChangeView()));
  const PasswordChangeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PasswordChangeViewState();
}

final obscureTextProvider = StateProvider.autoDispose((ref) {
  return true;
});

final obscureTextProvider2 = StateProvider.autoDispose((ref) {
  return true;
});

class _PasswordChangeViewState extends ConsumerState<PasswordChangeView> {
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController oldPasswordTextEditingController =
      TextEditingController();

  @override
  void dispose() {
    passwordTextEditingController.dispose();
    oldPasswordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final obscureText = ref.watch(obscureTextProvider);
    final obscureText2 = ref.watch(obscureTextProvider2);

    final textTheme = Theme.of(context).textTheme;
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
      appBar: appBar(
        const Text('Update password'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFieldLabel(textTheme: textTheme, label: 'Old password'),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(
              obscureText: obscureText,
              suffixIcon: IconButton(
                onPressed: () {
                  ref.read(obscureTextProvider.notifier).update(
                        (state) => !state,
                      );
                },
                icon: CustomImageIcon(
                  iconPath: obscureText
                      ? Assets.icons.hide.path
                      : Assets.icons.show.path,
                ),
              ),
              controller: oldPasswordTextEditingController,
            ),
            const SizedBox(
              height: 16,
            ),
            TextFieldLabel(textTheme: textTheme, label: 'New password'),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(
              obscureText: obscureText2,
              suffixIcon: IconButton(
                onPressed: () {
                  ref.read(obscureTextProvider2.notifier).update(
                        (state) => !state,
                      );
                },
                icon: CustomImageIcon(
                  iconPath: obscureText2
                      ? Assets.icons.hide.path
                      : Assets.icons.show.path,
                ),
              ),
              controller: passwordTextEditingController,
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                buttonType: ButtonType.filled,
                buttonSize: ButtonSize.large,
                child: const Text('Update'),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  ref.read(settingsControllerProvider.notifier).updatePassword(
                        context: context,
                        password: passwordTextEditingController.text,
                        oldPassword: oldPasswordTextEditingController.text,
                      );
                },
              ),
            ),
          ],
        ).addFullPading(16),
      ),
    );
  }
}
