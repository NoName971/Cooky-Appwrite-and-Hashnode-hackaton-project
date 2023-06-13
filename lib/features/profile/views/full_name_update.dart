import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackaton_v1/common/appbar.dart';
import 'package:hackaton_v1/common/custom_textfield.dart';
import 'package:hackaton_v1/helpers/extensions.dart';
import 'package:hackaton_v1/features/create_recipe/widgets/textfield_label_widget.dart';
import 'package:hackaton_v1/controllers/profile_controller.dart';

import '../../../common/custom_button.dart';
import '../../../helpers/utils.dart';

class FullNameUpdate extends ConsumerStatefulWidget {
  static route() =>
      MaterialPageRoute(builder: ((context) => const FullNameUpdate()));
  const FullNameUpdate({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FullNameUpdateState();
}

class _FullNameUpdateState extends ConsumerState<FullNameUpdate> {
  TextEditingController newFullNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
        const Text('Update name'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldLabel(textTheme: textTheme, label: 'New name'),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                controller: newFullNameController,
                validator: (value) {
                  if (value == null || value.length < 5) {
                    return '5 characters minimum';
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
                  child: const Text('Update'),
                  onPressed: () {
                    final validation = _formKey.currentState!.validate();
                    if (validation) {
                      FocusScope.of(context).unfocus();
                      if (newFullNameController.text.isNotEmpty) {
                        ref.read(profileProvider.notifier).updateFullName(
                              context: context,
                              name: newFullNameController.text,
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
