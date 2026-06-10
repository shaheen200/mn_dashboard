// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CustomDateBtn extends StatelessWidget {
  final void Function(String)? onSelect;
  final Color? color;
  const CustomDateBtn({super.key, required this.onSelect, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
          onTap: () async {
            DateTime? date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2024),
                lastDate: DateTime(2124));
            if (date != null) {
              onSelect!.call("$date".split(" ")[0]);
            } else {
              onSelect!.call("");
            }
          },
          child: Icon(Icons.alarm,
              color: color ?? Theme.of(context).primaryColorDark, size: 35)),
    );
  }
}
