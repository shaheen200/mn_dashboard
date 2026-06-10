// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mn1/tools/customText.dart';

class CustomFileImage extends StatelessWidget {
  final double h;
  final double w;
  final String path;
  const CustomFileImage({
    super.key,
    required this.path,
    required this.w,
    required this.h,
  });

  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(path),
      width: w,
      height: h,
      filterQuality: FilterQuality.high,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return TEXT(text: 'لا يوجد صوره', size: 15, center: true);
      },
    );
  }
}
