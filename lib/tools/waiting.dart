import 'package:flutter/material.dart';

void waiting({required BuildContext context}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      });
}

void pOP(BuildContext context) {
  Navigator.pop(context);
}
