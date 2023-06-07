import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackaton_v1/common/custom_button.dart';
import 'package:hackaton_v1/features/auth/controller/auth_controller.dart';

class ErrorView extends ConsumerStatefulWidget {
  const ErrorView({super.key, required this.error});

  final String error;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ErrorViewState();
}

class _ErrorViewState extends ConsumerState<ErrorView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.error),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                buttonType: ButtonType.filled,
                buttonSize: ButtonSize.large,
                child: const Text('Retry'),
                onPressed: () {
                  ref.invalidate(authControllerProvider);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
