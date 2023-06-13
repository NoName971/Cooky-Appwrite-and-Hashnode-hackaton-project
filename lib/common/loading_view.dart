import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadingView extends ConsumerStatefulWidget {
  const LoadingView({super.key, this.logo});

  final Widget? logo;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoadingViewState();
}

class _LoadingViewState extends ConsumerState<LoadingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.logo ?? const SizedBox.shrink(),
          Visibility(
            visible: widget.logo != null,
            child: const SizedBox(
              height: 20,
            ),
          ),
          const Center(
            child: CircularProgressIndicator(),
          ),
          const SizedBox(
            height: kToolbarHeight,
          ),
        ],
      ),
    );
  }
}
