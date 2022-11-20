import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

void toast(BuildContext context, String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color.fromARGB(255, 73, 73, 73),
      textColor: Colors.white,
      fontSize: 16.0);
}
