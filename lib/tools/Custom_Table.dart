// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:mn1/tools/container/custom_container.dart';

class CustomHeadTableItems {
  final int flex;
  final String text;
  final bool show;
  final Color? color;
  CustomHeadTableItems({
    required this.flex,
    required this.text,
    this.show = true,
    this.color,
  });
}

class CustomHeadTable extends StatelessWidget {
  final List<CustomHeadTableItems> headData;
  const CustomHeadTable({super.key, required this.headData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: headData.where((element) => element.show).toList().map((e) {
          return Expanded(
            flex: e.flex,
            child: Text(
              e.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: e.color ?? Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontFamily: "tajawal",
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class CustomBodyTableItems {
  final int flex;
  final Widget widget;
  final bool show;
  CustomBodyTableItems({
    required this.flex,
    required this.widget,
    this.show = true,
  });
}

class CustomBodyTable extends StatelessWidget {
  final List<CustomBodyTableItems> bodyData;
  const CustomBodyTable({super.key, required this.bodyData});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      radius: 14,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: bodyData.where((element) => element.show).toList().map((e) {
          return Expanded(
            flex: e.flex,
            child: Center(child: e.widget),
          );
        }).toList(),
      ),
    );
  }
}
