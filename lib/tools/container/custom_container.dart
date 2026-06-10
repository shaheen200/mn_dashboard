// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Widget child;
  final double? radius;
  final double? width;
  final double? height;
  const CustomContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.radius,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(10),
      margin: margin ?? const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(radius ?? 20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColorDark.withOpacity(0.25),
            blurRadius: 2,
            offset: Offset.zero,
            spreadRadius: 0,
          ),
        ],
      ),

      child: child,
    );
  }
}
