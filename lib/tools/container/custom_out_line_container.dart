// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class CustomOutLineContainer extends StatelessWidget {
  final double width;
  final double? height;
  final Color? color;
  final EdgeInsets? pading;
  final EdgeInsets? margin;
  final double raduis;
  final Widget? child;
  final void Function()? onTap;
  const CustomOutLineContainer({
    super.key,
    required this.width,
    this.height,
    this.color,
    this.pading,
    this.margin,
    this.raduis = 15,
    this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: pading ?? EdgeInsets.all(20),
        margin: margin ?? EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width * width,
        height:
            height == null
                ? null
                : (MediaQuery.of(context).size.height * height!),
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(raduis),
          border: Border.all(width: 2, color: Theme.of(context).primaryColor),
        ),
        child: child,
      ),
    );
  }
}
