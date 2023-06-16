import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackaton_v1/common/appbar.dart';
import 'package:hackaton_v1/common/custom_textfield.dart';
import 'package:hackaton_v1/controllers/auth_controller.dart';
import 'package:hackaton_v1/helpers/extensions.dart';
import 'package:hackaton_v1/features/create_recipe/widgets/textfield_label_widget.dart';
import 'package:hackaton_v1/controllers/settings_controller.dart';

import '../../../common/custom_button.dart';
import '../../../helpers/utils.dart';

class PasswordRecoveryView extends ConsumerStatefulWidget {
  static route() =>
      MaterialPageRoute(builder: ((context) => const PasswordRecoveryView()));
  const PasswordRecoveryView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PasswordRecoveryViewState();
}

class _PasswordRecoveryViewState extends ConsumerState<PasswordRecoveryView> {
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
        const Text('Forgot password'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldLabel(
                textTheme: textTheme,
                label: 'Enter your email address',
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email required';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  buttonType: ButtonType.filled,
                  buttonSize: ButtonSize.large,
                  child: const Text('Recover password'),
                  onPressed: () {
                    final validation = _formKey.currentState!.validate();
                    if (validation) {
                      FocusScope.of(context).unfocus();
                      if (emailController.text.isNotEmpty) {
                        ref
                            .read(authControllerProvider.notifier)
                            .sendPasswordRecoveryEmail(
                              email: emailController.text,
                              context: context,
                            );
                      }
                    }
                  },
                ),
              ),
            ],
          ).addFullPading(16),
        ),
      ),
    );
  }
}
