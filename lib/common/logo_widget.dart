import 'package:flutter/material.dart';
import 'package:hackaton_v1/common/custom_image_icon.dart';
import 'package:hackaton_v1/common/text_style.dart';
import 'package:hackaton_v1/gen/assets.gen.dart';

class LogoLargeWidget extends StatelessWidget {
  const LogoLargeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomImageIcon(
          iconPath: Assets.icons.pot.path,
          color: context.colorScheme.primary,
          size: 50,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Cooky',
          style: context.h1,
        ),
      ],
    );
  }
}

class LogoSmallWidget extends StatelessWidget {
  const LogoSmallWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomImageIcon(
      color: context.colorScheme.primary,
      iconPath: Assets.icons.pot.path,
      size: 30,
    );
  }
}
