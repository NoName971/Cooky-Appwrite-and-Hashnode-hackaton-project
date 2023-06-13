import 'package:flutter/material.dart';
import 'package:hackaton_v1/common/text_style.dart';

class LogoLargeWidget extends StatelessWidget {
  const LogoLargeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'Cooky 👨🏿‍🍳',
      style: context.h1,
    );
  }
}

class LogoSmallWidget extends StatelessWidget {
  const LogoSmallWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'Cooky 👨🏿‍🍳',
      style: context.h3,
    );
  }
}
