import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mn1/tools/customText.dart';

class CustomMemoryImage extends StatelessWidget {
  final double h;
  final double w;
  final Uint8List? bytes;
  const CustomMemoryImage({
    super.key,
    required this.bytes,
    required this.w,
    required this.h,
  });

  @override
  Widget build(BuildContext context) {
    if (bytes == null) {
      return TEXT(text: 'لا يوجد صوره', size: 15, center: true);
    }

    return Image.memory(
      bytes!,
      width: w,
      height: h,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }
}
