import 'package:flutter/material.dart';
import 'package:hackaton_v1/common/text_style.dart';

class TextFieldLabel extends StatelessWidget {
  const TextFieldLabel({
    super.key,
    required this.textTheme,
    required this.label,
  });

  final TextTheme textTheme;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: context.p2Medium,
    );
  }
}
