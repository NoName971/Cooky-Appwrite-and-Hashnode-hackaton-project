import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackaton_v1/common/custom_image_icon.dart';
import 'package:hackaton_v1/common/text_style.dart';
import 'package:hackaton_v1/gen/assets.gen.dart';
import '../../../common/custom_button.dart';
import '../../../common/custom_textfield.dart';
import '../../../helpers/utils.dart';
import '../../../controllers/auth_controller.dart';

final obscureTextProvider = StateProvider.autoDispose((ref) {
  return true;
});

class RegisterView extends ConsumerStatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const RegisterView());

  const RegisterView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final obscureText = ref.watch(obscureTextProvider);

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
      appBar: AppBar(
        title: const Text(
          'Register',
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 60,
              ),
              CustomTextField(
                controller: emailController,
                label: const Text('Email'),
              ),
              const SizedBox(
                height: 16,
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
                controller: passwordController,
                label: const Text('Password'),
              ),
              const SizedBox(
                height: 16,
              ),
              CustomTextField(
                controller: fullNameController,
                label: const Text('Full name ( optional )'),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  buttonType: ButtonType.filled,
                  buttonSize: ButtonSize.large,
                  child: const Text('Register'),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    if (passwordController.text.isNotEmpty ||
                        passwordController.text.isNotEmpty) {
                      return ref.read(authControllerProvider.notifier).register(
                            email: emailController.text,
                            password: passwordController.text,
                            fullName: fullNameController.text.isNotEmpty
                                ? fullNameController.text
                                : null,
                            context: context,
                          );
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: context.colorScheme.onBackground),
                      text: 'Have an account?',
                    ),
                    TextSpan(
                      text: ' Login',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        color: context.colorScheme.primary,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: kToolbarHeight,
              ),
            ],
          ),
        );
      }),
    );
  }
}
