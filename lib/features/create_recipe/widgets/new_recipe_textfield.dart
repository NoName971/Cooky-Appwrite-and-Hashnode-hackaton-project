import 'package:flutter/material.dart';

import '../../../common/custom_textfield.dart';
import 'textfield_label_widget.dart';

class NewRecipeTextField extends StatefulWidget {
  const NewRecipeTextField({
    super.key,
    required this.textTheme,
    required this.textEditingController,
    required this.label,
    required this.hintText,
    this.maxLines,
    this.maxLength = 100,
    this.validator,
  });

  final TextTheme textTheme;
  final TextEditingController textEditingController;
  final String label;
  final String hintText;
  final dynamic maxLines;
  final int maxLength;
  final String? Function(String?)? validator;

  @override
  State<NewRecipeTextField> createState() => _NewRecipeTextFieldState();
}

class _NewRecipeTextFieldState extends State<NewRecipeTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldLabel(
          textTheme: widget.textTheme,
          label: widget.label,
        ),
        const SizedBox(
          height: 8,
        ),
        CustomTextField(
          maxLength: widget.maxLength,
          controller: widget.textEditingController,
          hintText: widget.hintText,
          maxlines: widget.maxLines,
          validator: widget.validator,
        )
      ],
    );
  }
}
