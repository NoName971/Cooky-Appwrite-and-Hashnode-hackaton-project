import 'package:flutter/material.dart';

class CustomImageIcon extends StatelessWidget {
  final String iconPath;
  final Color? color;
  final double size;
  const CustomImageIcon(
      {super.key, required this.iconPath, this.color, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: ImageIcon(
        color: color,
        AssetImage(iconPath),
        size: size,
      ),
    );
  }
}
