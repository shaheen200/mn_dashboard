// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../customText.dart';

class CustomPop extends StatelessWidget {
  final List<CustomPopItems> items;
  final Color? color;
  final double? iconSize;
  final IconData? icon;

  const CustomPop({
    super.key,
    required this.items,
    this.color,
    this.icon,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopupMenuButton<String>(
      color: theme.cardColor,
      elevation: 12,
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.dividerColor.withOpacity(0.1), width: 1),
      ),
      // تم تبسيط الـ AnimationStyle ليتوافق تماماً مع فلاتر ويمنع ظهور الخطأ
      popUpAnimationStyle: AnimationStyle(
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 200),
      ),
      position: PopupMenuPosition.under,
      itemBuilder: (BuildContext context) => filterItems().map((e) {
        return PopupMenuItem<String>(
          mouseCursor: SystemMouseCursors.click,
          onTap: e.onTap,
          value: e.text,
          child: Row(
            children: [
              Icon(e.icon, size: 20, color: theme.primaryColor),
              const SizedBox(width: 12),
              Expanded(
                child: TEXT(
                  text: e.text,
                  size: 15,
                  bold: true,
                  color: theme.primaryColorDark,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onSelected: (String? value) {},
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: theme.primaryColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon ?? Icons.more_vert_rounded,
          size: iconSize ?? 22,
          color: color ?? theme.primaryColor,
        ),
      ),
    );
  }

  List<CustomPopItems> filterItems() {
    return items.where((element) => element.show).toList();
  }
}

class CustomPopItems {
  final void Function()? onTap;
  final String text;
  final IconData icon;
  final bool show;

  CustomPopItems({
    required this.onTap,
    required this.text,
    required this.icon,
    this.show = true,
  });
}
