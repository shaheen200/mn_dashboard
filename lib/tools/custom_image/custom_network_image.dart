// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:mn1/tools/custom_image/custom_image.dart';

class CustomNetworkImage extends StatelessWidget {
  final double h;
  final double w;
  final String url;
  const CustomNetworkImage({
    super.key,
    required this.url,
    required this.w,
    required this.h,
  });

  @override
  Widget build(BuildContext context) {
    return url.isNotEmpty
        ? Image.network(
            url.replaceAll('http://10.0.2.2:8084', 'http://localhost:8084'),
            width: w,
            height: w,
            filterQuality: FilterQuality.high,
            errorBuilder: (context, error, stackTrace) {
              return CustomImage(path: 'image/logo.png', w: w, h: h);
            },
            fit: BoxFit.contain,
          )
        : CustomImage(path: 'image/logo.png', w: w, h: h);
  }
}
