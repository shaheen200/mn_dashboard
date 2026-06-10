// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  final void Function()? onClick;
  final String text;
  final double w;
  final Color? textcolor;
  final double raduis;
  final Color? btnColor;
  final double height;
  const CustomBtn({
    super.key,
    this.btnColor,
    required this.onClick,
    this.textcolor,
    required this.text,
    this.raduis = 30,
    this.height = 45,
    this.w = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onClick,
      color: btnColor ?? Theme.of(context).primaryColor,
      focusColor: Theme.of(context).primaryColorDark.withRed(170),
      splashColor: Colors.black45,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(raduis),
      ),
      elevation: 0,
      hoverElevation: 4,
      focusElevation: 4,
      minWidth: MediaQuery.of(context).size.width * w,
      height: height,
      child: Text(
        text,
        style: const TextStyle(fontSize: 17, color: Colors.white),
      ),
    );
  }
}
