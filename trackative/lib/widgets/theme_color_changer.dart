import 'package:flutter/material.dart';

Color themeColorChanger(
  BuildContext context,
  Color trueColor,
  Color falseColor,
) {
  return Theme.of(context).scaffoldBackgroundColor == Colors.black
      ? trueColor
      : falseColor;
}
