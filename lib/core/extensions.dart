import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension ContextExtensions on BuildContext {
  executeIfMounted(callback) {
    if (mounted) {
      callback();
    }
  }
}

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

extension StringExtensions on String {
  convertToDate() {
    return DateFormat.yMMMMEEEEd('en_US')
        .add_Hm()
        .format(DateTime.parse(this))
        .toString();
  }
}
