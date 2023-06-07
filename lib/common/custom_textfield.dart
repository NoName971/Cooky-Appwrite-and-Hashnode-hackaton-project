import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextStyle? style;
  final String? hintText;
  final Widget? preffixIcon;
  final Widget? icon;
  final Widget? suffixIcon;
  final TextStyle? hintStyle;
  final bool obscureText;
  final bool enabled;
  final Widget? label;
  final TextStyle? labelStyle;

  final String? Function(String?)? validator;

  final int? maxLength;

  final void Function()? onTap;
  final void Function(String)? onChanged;

  final int? maxlines;
  final bool autoFocus;
  final List<TextInputFormatter>? inputFormatters;

  final bool readOnly;
  const CustomTextField({
    Key? key,
    this.controller,
    this.enabled = true,
    this.obscureText = false,
    this.initialValue,
    this.focusNode,
    this.keyboardType,
    this.style,
    this.readOnly = false,
    this.hintText,
    this.preffixIcon,
    this.onTap,
    this.maxlines = 1,
    this.icon,
    this.maxLength,
    this.inputFormatters,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.hintStyle,
    this.autoFocus = false,
    this.label,
    this.labelStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      maxLines: maxlines,
      maxLength: maxLength,
      controller: controller,
      initialValue: initialValue,
      validator: validator,
      textAlignVertical: TextAlignVertical.center,
      readOnly: readOnly,
      onTap: onTap,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      enabled: enabled,
      keyboardType: keyboardType,
      style: style,
      autofocus: autoFocus,
      decoration: InputDecoration(
        label: label,
        labelStyle: labelStyle,
        fillColor: Colors.transparent,
        suffixIcon: suffixIcon,
        errorStyle: const TextStyle(fontWeight: FontWeight.w600),
        counterText: '',
        icon: icon,
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        filled: true,
        hintStyle: hintStyle,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        // enabledBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(8),
        // ),
        // focusedBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(8),
        // ),
        prefixIcon: preffixIcon,
      ),
    );
  }
}
