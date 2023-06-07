import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    Key? key,
    this.leading,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.verticalPadding = 8,
    this.contentPadding = EdgeInsets.zero,
  }) : super(key: key);

  final Widget? leading;
  final Widget? trailing;

  final Widget title;
  final Widget? subtitle;
  final void Function()? onTap;
  final double verticalPadding;
  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity.standard,
      minVerticalPadding: verticalPadding,
      onTap: onTap,
      contentPadding: contentPadding,
      leading: leading,
      minLeadingWidth: 16,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
    );
  }
}
