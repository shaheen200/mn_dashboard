import 'package:flutter/material.dart';
import 'package:mn1/methods/page_size.dart';
import 'package:mn1/tools/container/custom_container.dart';
import 'package:mn1/tools/customText.dart';

class CustomSwitchBtn extends StatefulWidget {
  final String text;
  final bool value;
  final bool enable;
  final void Function(bool p0)? onChanged;
  const CustomSwitchBtn({
    super.key,
    this.enable = true,
    required this.text,
    required this.value,
    required this.onChanged,
  });

  @override
  State<CustomSwitchBtn> createState() => _CustomSwitchBtnState();
}

class _CustomSwitchBtnState extends State<CustomSwitchBtn> {
  bool check = false;
  @override
  void initState() {
    check = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: pageSizeWidth(context, 1),

      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: TEXT(text: widget.text, size: 18, bold: true)),
            Switch(
              value: check,
              onChanged: (value) {
                if (widget.enable) {
                  setState(() {
                    check = value;
                  });
                  widget.onChanged!.call(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
