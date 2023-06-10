import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackaton_v1/common/custom_button.dart';
import 'package:hackaton_v1/constants/ui_messages.dart';

class ErrorView extends ConsumerStatefulWidget {
  const ErrorView({
    super.key,
    required this.provider,
  });

  final ProviderBase provider;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ErrorViewState();
}

class _ErrorViewState extends ConsumerState<ErrorView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(UiMessages.unexpectedError),
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
                  ref.invalidate(widget.provider);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
