// ignore_for_file: file_names

import 'package:flutter/material.dart';

class TEXT extends StatelessWidget {
  final String text;
  final double size;
  final bool bold;
  final bool center;
  final Color? color;
  final TextDirection? dir;
  const TEXT(
      {super.key,
      required this.text,
      required this.size,
      this.color,
      this.center = false,
      this.dir,
      this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      textDirection: dir,
      text,
      softWrap: true,
      maxLines: 3,
      textAlign: center ? TextAlign.center : null,
      style: TextStyle(
          fontSize: size,
          color: color ?? Theme.of(context).primaryColorDark,
          fontFamily: "tajawal",
          fontWeight: bold ? FontWeight.bold : FontWeight.normal),
    );
  }
}
