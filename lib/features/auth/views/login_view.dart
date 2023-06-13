import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackaton_v1/common/custom_button.dart';
import 'package:hackaton_v1/common/custom_image_icon.dart';
import 'package:hackaton_v1/common/custom_textfield.dart';
import 'package:hackaton_v1/common/logo_widget.dart';
import 'package:hackaton_v1/common/text_style.dart';
import 'package:hackaton_v1/gen/assets.gen.dart';
import 'package:hackaton_v1/helpers/utils.dart';
import 'package:hackaton_v1/controllers/auth_controller.dart';
import 'package:hackaton_v1/features/auth/views/register_view.dart';

final obscureTextProvider = StateProvider.autoDispose((ref) {
  return true;
});

class LoginView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const LoginView());
  const LoginView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
      appBar: AppBar(),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    const LogoLargeWidget(),
                    const SizedBox(
                      height: 50,
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
                      controller: passwordController,
                      label: const Text('Password'),
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
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        buttonType: ButtonType.filled,
                        buttonSize: ButtonSize.large,
                        child: const Text('Login'),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          ref.read(authControllerProvider.notifier).login(
                                ref: ref,
                                email: emailController.text,
                                password: passwordController.text,
                                context: context,
                              );
                        },
                      ),
                    ),
                    const Spacer(),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            style: TextStyle(
                                fontFamily: 'DMSans',
                                color: context.colorScheme.onBackground),
                            text: 'Don\'t have an account?',
                          ),
                          TextSpan(
                            text: ' Register',
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              fontWeight: FontWeight.w600,
                              color: context.colorScheme.primary,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                FocusScope.of(context).unfocus();
                                Navigator.push(context, RegisterView.route());
                              },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: kToolbarHeight,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
