// ignore_for_file: file_names

import 'package:flutter/material.dart';

Future<void> goPage(BuildContext context, Widget child) async {
  await Navigator.push(context, MaterialPageRoute(builder: (context) => child));
}

void goToPage(BuildContext context, Widget child) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => child));
}

void goToPage2(BuildContext context, Widget child) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => child),
    (Route<dynamic> route) => false,
  );
}
