// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  final double h;
  final double w;
  final String path;
  const CustomImage(
      {super.key, required this.path, required this.w, required this.h});

  @override
  Widget build(BuildContext context) {
    return Image.asset(path,
        width: MediaQuery.of(context).size.width * w,
        height: MediaQuery.of(context).size.height * h,
        filterQuality: FilterQuality.high,
        fit: BoxFit.contain);
  }
}
