import 'package:flutter/material.dart';

extension PaddingExtension on Widget {
  addHorizontalPadding(double padding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: this,
    );
  }

  addFullPading(double padding) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: this,
    );
  }

  addSymetricPadding({double? horizontal, double? vertical}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: vertical ?? 0,
        horizontal: horizontal ?? 0,
      ),
      child: this,
    );
  }
}

String getInitials(String inputString) {
  List<String> words = inputString.split(' ');
  String firstLetters = '';

  int wordCount = 0;
  for (var word in words) {
    if (word.isNotEmpty) {
      firstLetters += '${word[0].toUpperCase()} ';
      wordCount++;
      if (wordCount == 2) {
        break;
      }
    }
  }

  return firstLetters.trimRight();
}
