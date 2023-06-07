import 'package:flutter/material.dart';

AppBar appBar(Widget title, [bool? centerTitle, List<Widget>? actions]) {
  return AppBar(
    scrolledUnderElevation: 0,
    elevation: 0,
    title: title,
    centerTitle: centerTitle ?? true,
    actions: actions ?? [],
  );
}
