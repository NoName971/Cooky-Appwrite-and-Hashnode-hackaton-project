import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackaton_v1/common/custom_button.dart';
import 'package:hackaton_v1/common/custom_textfield.dart';
import 'package:hackaton_v1/helpers/utils.dart';
import 'package:hackaton_v1/controllers/auth_controller.dart';
import 'package:hackaton_v1/features/auth/views/register_view.dart';
import 'package:hackaton_v1/features/discover/views/discovery_view.dart';
import 'package:hackaton_v1/main.dart';

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
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            CustomTextField(
              controller: emailController,
              label: const Text('Email'),
            ),
            const SizedBox(
              height: 16,
            ),
            CustomTextField(
              controller: passwordController,
              label: const Text('Password'),
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Forgot password?',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
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
                          email: emailController.text,
                          password: passwordController.text,
                          context: context,
                        );
                  }),
            ),
            const Spacer(),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        logger.d(ref.read(recipesProvider).length);
                      },
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: colorScheme.onBackground),
                    text: 'Don\'t have an account?',
                  ),
                  TextSpan(
                    text: ' Register',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap =
                          () => Navigator.push(context, RegisterView.route()),
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
    );
  }
}
