// ignore_for_file: empty_catches

import 'package:flutter/material.dart';
import 'package:mn1/tools/container/custom_container.dart';
import '../customText.dart';

enum CustomFieldType { text, number, time, date }

class CustomField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? Function(String?)? validator;
  final IconData icon;
  final bool enable;
  final bool pw;
  final int? maxLines;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final CustomFieldType type;
  final int? maxLength;
  const CustomField({
    super.key,
    this.controller,
    this.maxLines = 1,
    this.onChanged,
    this.enable = true,
    this.pw = false,
    this.labelText,
    this.hintText,
    required this.icon,
    this.onFieldSubmitted,
    this.validator,
    this.maxLength,
    this.type = CustomFieldType.text,
  });

  @override
  State<CustomField> createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  bool show = false;
  @override
  void initState() {
    show = widget.pw;

    if (widget.type == CustomFieldType.number) {
      if (widget.controller != null) {
        widget.controller!.addListener(() {
          final filteredText = returnNumberOnly(widget.controller!.text);
          if (widget.controller!.text != filteredText) {
            widget.controller!.value = widget.controller!.value.copyWith(
              text: filteredText,
              selection: TextSelection.collapsed(offset: filteredText.length),
            );
          }
        });
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.type == CustomFieldType.date) {
          final now = DateTime.now();

          final date = await showDatePicker(
            context: context,
            firstDate: DateTime(2024),
            lastDate: now.add(Duration(days: 360)),
            initialDate: now,
          );
          if (date != null) {
            if (widget.onChanged != null) {
              widget.onChanged!.call(date.toString().split(' ')[0]);
            }
            if (widget.controller != null) {
              widget.controller!.text = date.toString().split(' ')[0];
            }
          }
        } else if (widget.type == CustomFieldType.time) {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (time != null) {
            if (widget.onChanged != null) {
              widget.onChanged!.call("${time.hour} : ${time.minute}");
            }
            if (widget.controller != null) {
              widget.controller!.text = "${time.hour} : ${time.minute}";
            }
          }
        }
      },
      child: Column(
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
            padding: EdgeInsets.only(
              top: widget.pw ? 2 : 10,
              bottom: widget.pw ? 2 : 10,
              left: 17,
              right: 17,
            ),

            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    maxLength: widget.maxLength,
                    onFieldSubmitted: widget.onFieldSubmitted,
                    obscureText: show,
                    style: TextStyle(color: Theme.of(context).primaryColorDark),
                    maxLines: widget.maxLines,
                    enabled:
                        (widget.type == CustomFieldType.time ||
                            widget.type == CustomFieldType.date)
                        ? false
                        : widget.enable,
                    onChanged: (value) {
                      try {
                        if (widget.onChanged != null) {
                          widget.onChanged!.call(value);
                        }
                      } catch (e) {}
                    },
                    controller: widget.controller,
                    validator: widget.validator,

                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        color: Theme.of(
                          context,
                        ).primaryColorDark.withOpacity(0.5),
                      ),
                      hintText: widget.hintText,
                      contentPadding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                      ),
                      isDense: true,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                widget.pw
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            show = !show;
                          });
                        },
                        icon: Icon(
                          show ? Icons.visibility_off : Icons.visibility,
                          color: Theme.of(
                            context,
                          ).primaryColorDark.withOpacity(0.7),
                        ),
                      )
                    : Icon(
                        widget.icon,
                        color: Theme.of(
                          context,
                        ).primaryColorDark.withOpacity(0.7),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String returnNumberOnly(String input) {
  if (input.isNotEmpty) {
    return input.replaceAll(RegExp(r'[^0-9.]'), '');
  }
  return '';
}
