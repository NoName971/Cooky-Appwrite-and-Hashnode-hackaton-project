import 'package:flutter/material.dart';
import 'package:hackaton_v1/common/text_style.dart';

class CategoryChipWidget extends StatelessWidget {
  final Widget icon;
  final String categoryName;
  const CategoryChipWidget({
    super.key,
    required this.icon,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      label: Text(
        categoryName,
        style: context.p3Medium,
      ),
      avatar: icon,
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
    );
  }
}
