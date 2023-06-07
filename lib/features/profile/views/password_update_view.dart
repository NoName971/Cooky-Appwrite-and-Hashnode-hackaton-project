import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackaton_v1/common/appbar.dart';
import 'package:hackaton_v1/common/custom_textfield.dart';
import 'package:hackaton_v1/core/extensions.dart';
import 'package:hackaton_v1/features/create_recipe/widgets/textfield_label_widget.dart';
import 'package:hackaton_v1/features/profile/controller/profile_controller.dart';

import '../../../common/custom_button.dart';
import '../../../core/utils.dart';

class PasswordChangeView extends ConsumerStatefulWidget {
  static route() =>
      MaterialPageRoute(builder: ((context) => const PasswordChangeView()));
  const PasswordChangeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PasswordChangeViewState();
}

class _PasswordChangeViewState extends ConsumerState<PasswordChangeView> {
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController oldPasswordTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
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
                    ref.read(profileProvider.notifier).updatePassword(
                          context: context,
                          password: passwordTextEditingController.text,
                          oldPassword: oldPasswordTextEditingController.text,
                        );
                  }),
            ),
          ],
        ).addFullPading(16),
      ),
    );
  }
}
