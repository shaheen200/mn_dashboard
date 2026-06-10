import 'package:flutter/material.dart';

import '../customText.dart';

class CustomPop extends StatelessWidget {
  final List<CustomPopItems> items;
  final Color? color;
  final double? iconSize;
  final IconData? icon;
  const CustomPop(
      {super.key, required this.items, this.color, this.icon, this.iconSize});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: Theme.of(context).primaryColorLight,
      elevation: 6,
      popUpAnimationStyle: AnimationStyle(
          curve: Curves.fastOutSlowIn,
          reverseCurve: Curves.decelerate,
          reverseDuration: const Duration(seconds: 1),
          duration: const Duration(milliseconds: 400)),
      position: PopupMenuPosition.under,
      itemBuilder: (BuildContext context) => filterItems().map((e) {
        return PopupMenuItem<String>(
          mouseCursor: SystemMouseCursors.click,
          onTap: e.onTap,
          value: e.text,
          child: TEXT(
            text: e.text!,
            size: 17,
            bold: true,
            color: Theme.of(context).primaryColorDark,
          ),
        );
      }).toList(),
      onSelected: (String? value) {
        // Handle menu item selection here
      },
      child: Icon(
        icon ?? Icons.more_vert_rounded,
        size: iconSize ?? 25,
        color: color ?? Theme.of(context).primaryColorDark,
      ),
    );
  }

  List<CustomPopItems> filterItems() {
    return items.where((element) => element.show!).toList();
  }
}

class CustomPopItems {
  void Function()? onTap;
  String? text;
  bool? show;
  CustomPopItems({this.onTap, this.text, this.show = true});
}
