import 'package:flutter/material.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/custom_dialog.dart';
import 'package:mn1/tools/custom_field/custom_field.dart';
import 'package:mn1/tools/waiting.dart';

class CustomBtnDateBetween extends StatelessWidget {
  final void Function(String start, String end) onselect;
  const CustomBtnDateBetween({super.key, required this.onselect});

  @override
  Widget build(BuildContext context) {
    final TextEditingController date1 = .new();
    final TextEditingController date2 = .new();
    final GlobalKey<FormState> formKey = .new();

    return IconButton(
      onPressed: () {
        customDialog(
          context: context,
          width: 0.4,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomField(
                  icon: Icons.date_range,
                  type: CustomFieldType.date,
                  controller: date1,
                  labelText: getText("from"),
                  onChanged: (p0) {
                    date1.text = p0;
                  },
                  validator: (p0) {
                    if (p0 == null) {
                      return getText("field_empty");
                    }
                    if (p0.isEmpty) {
                      return getText("field_empty");
                    }
                    return null;
                  },
                ),
                CustomField(
                  icon: Icons.date_range,
                  type: CustomFieldType.date,
                  controller: date2,
                  labelText: getText("to"),
                  onChanged: (p0) {
                    date2.text = p0;
                  },
                  validator: (p0) {
                    if (p0 == null) {
                      return getText("field_empty");
                    }
                    if (p0.isEmpty) {
                      return getText("field_empty");
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          ok: () {
            if (formKey.currentState!.validate()) {
              pOP(context);
              onselect.call(date1.text, date2.text);
            }
          },
        );
      },
      icon: Icon(
        Icons.alarm,
        color: Theme.of(context).primaryColorDark,
        size: 35,
      ),
    );
  }
}
