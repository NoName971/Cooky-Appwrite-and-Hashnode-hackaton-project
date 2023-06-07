import 'package:flutter/material.dart';

extension CustomStyles on BuildContext {
  TextStyle get h1 {
    return const TextStyle(
      fontSize: 36,
      height: 1.27,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle get h2 {
    return const TextStyle(
      fontSize: 24,
      // height: 34,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle get h3 {
    return const TextStyle(
      fontSize: 22,
      // height: 32,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle get h4 {
    return const TextStyle(
      fontSize: 18,
      // height: 28,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle get h5 {
    return const TextStyle(
      fontSize: 16,
      // height: 26,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle get h6 {
    return const TextStyle(
      fontSize: 14,
      // height: 24,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle get p1Medium {
    return const TextStyle(
      fontSize: 18,
      // height: 28,
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle get p2Medium {
    return const TextStyle(
      fontSize: 16,
      // height: 26,
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle get p3Medium {
    return const TextStyle(
      fontSize: 14,
      height: 1.71,
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle get p1Regular {
    return const TextStyle(
      fontSize: 18,
      // height: 28,
      fontWeight: FontWeight.w400,
    );
  }

  TextStyle get p2Regular {
    return const TextStyle(
      fontSize: 16,
      // height: 26,
      fontWeight: FontWeight.w400,
    );
  }

  TextStyle get p3Regular {
    return const TextStyle(
      fontSize: 14,
      // height: 24,
      fontWeight: FontWeight.w400,
    );
  }

  TextStyle get keyboardDigits {
    return const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
    );
  }

  TextStyle get buttons {
    return const TextStyle(
      fontSize: 16,
      height: 1.625,
      fontWeight: FontWeight.w700,
    );
  }

  ColorScheme get colorScheme {
    return Theme.of(this).colorScheme;
  }
}
