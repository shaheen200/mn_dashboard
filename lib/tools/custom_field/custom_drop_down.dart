import 'package:flutter/material.dart';
import 'package:mn1/tools/container/custom_container.dart';
import 'package:mn1/tools/customText.dart';

class CustomDropDown extends StatefulWidget {
  final String? initValue;
  final String? labelText;
  final String? hintText;
  final String? Function(dynamic p0)? validator;
  final void Function(String p0)? onChanged;
  final List<CustomDropDownItems> items;
  const CustomDropDown({
    super.key,
    required this.items,
    this.onChanged,
    this.labelText,
    this.hintText,
    this.validator,
    this.initValue,
  });

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: widget.labelText == null ? false : true,
          child: TEXT(
            text: " ${widget.labelText} ",
            size: 18,
            bold: true,
            color: Theme.of(context).primaryColorDark,
          ),
        ),

        CustomContainer(
          padding: EdgeInsets.only(top: 10, bottom: 7, left: 17, right: 17),

          child: DropdownButtonFormField(
            items: widget.items.map((e) {
              return DropdownMenuItem<String>(
                value: e.value ?? e.text,
                onTap: e.onTap,
                child: TEXT(text: e.text, size: 17),
              );
            }).toList(),
            style: TextStyle(color: Theme.of(context).primaryColorDark),

            onChanged: (value) {
              try {
                if (widget.onChanged != null) {
                  widget.onChanged!.call(value.toString());
                }
              } catch (e) {}
            },
            initialValue: widget.initValue,
            validator: widget.validator,
            decoration: InputDecoration(
              hintStyle: TextStyle(
                color: Theme.of(context).primaryColorDark.withOpacity(0.5),
              ),
              hintText: widget.hintText,
              contentPadding: const EdgeInsets.only(left: 15, right: 15),
              isDense: true,
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}

class CustomDropDownItems {
  final String text;
  final String? value;
  final void Function()? onTap;
  const CustomDropDownItems({required this.text, this.value, this.onTap});
}
