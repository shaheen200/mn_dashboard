import 'package:flutter/material.dart';
import 'package:mn1/tools/container/custom_container.dart';
import 'package:mn1/tools/customText.dart';

class CustomRadioBtn extends StatefulWidget {
  final List<CustomRadioBtnItems> items;
  final void Function(String?)? onChanged;
  const CustomRadioBtn({
    super.key,
    required this.items,
    required this.onChanged,
  });

  @override
  State<CustomRadioBtn> createState() => _CustomRadioBtnState();
}

class _CustomRadioBtnState extends State<CustomRadioBtn> {
  String groubValue = "";
  @override
  void initState() {
    if (widget.items.isNotEmpty) {
      groubValue = widget.items.first.value;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.items.map((e) {
        return Expanded(
          child: CustomContainer(
            width: 1,

            child: Row(
              children: [
                Radio(
                  value: e.value,
                  groupValue: groubValue,
                  onChanged: (value) {
                    setState(() {
                      groubValue = e.value;
                    });
                    widget.onChanged!.call(e.value);
                  },
                ),
                const SizedBox(width: 10),
                TEXT(text: e.text, size: 18, bold: true),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class CustomRadioBtnItems {
  final String text;
  final String value;
  const CustomRadioBtnItems({required this.text, required this.value});
}
