import 'package:flutter/material.dart';

Text customText(
    String text, Color textColor, double fontSize, FontWeight fontWeight) {
  return Text(
    text,
    style:
        TextStyle(color: textColor, fontSize: fontSize, fontWeight: fontWeight),
  );
}
