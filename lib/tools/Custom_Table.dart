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
    return CustomContainer(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 10,
        children: headData.where((element) => element.show).toList().map((e) {
          return Expanded(
            flex: e.flex,
            child: Text(
              e.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: e.color ?? Theme.of(context).primaryColorDark,
                fontWeight: FontWeight.bold,
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
      width: double.infinity,
      child: Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
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
