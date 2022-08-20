import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:volunteer_project/utils/theme.dart';

void toast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: FontSize.smallFont);
}
