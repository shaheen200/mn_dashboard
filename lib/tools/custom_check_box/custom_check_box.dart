import 'package:flutter/material.dart';
import 'package:mn1/tools/customText.dart';

class CustomCheckBox extends StatefulWidget {
  final bool value;
  final void Function(bool?)? onChanged;
  final String text;
  const CustomCheckBox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.text,
  });

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  bool check = false;

  @override
  void initState() {
    check = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: check,
          onChanged: (value) {
            setState(() {
              check = value!;
            });
            widget.onChanged!.call(check);
          },
          activeColor: Colors.blue,
          checkColor: Colors.white,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          side: BorderSide(color: Colors.blue),
        ),
        Visibility(
          visible: widget.text.isNotEmpty,
          child: Row(
            children: [
              const SizedBox(width: 2),
              TEXT(
                text: widget.text,
                size: 17,
                bold: true,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
