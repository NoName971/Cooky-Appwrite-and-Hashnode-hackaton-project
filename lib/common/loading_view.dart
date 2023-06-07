import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadingView extends ConsumerStatefulWidget {
  const LoadingView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoadingViewState();
}

class _LoadingViewState extends ConsumerState<LoadingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
