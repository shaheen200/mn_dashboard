import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mn1/controller/application_controller.dart';
import 'package:mn1/database/department_base.dart';
import 'package:mn1/methods/empty_value.dart';
import 'package:mn1/models/department.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/custom_dialog.dart';
import 'package:mn1/tools/custom_field/custom_field.dart';
import 'package:mn1/tools/custom_image/custom_select_image.dart';
import 'package:mn1/tools/msg_dialog.dart';
import 'package:mn1/tools/waiting.dart';

void addDepartDialog(
  BuildContext context, {
  required ApplicationController<Department> controller,
}) {
  final TextEditingController name = .new();
  final GlobalKey<FormState> _formKey = .new();
  Uint8List? bytes;
  customDialog(
    context: context,
    width: 0.5,
    child: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: .center,
        mainAxisAlignment: .start,
        mainAxisSize: .min,
        spacing: 12,
        children: [
          TEXT(text: getText('create_depart'), size: 20, bold: true),
          Divider(
            color: Theme.of(context).primaryColorDark,
            height: 25,
            thickness: 2,
          ),

          Row(
            spacing: 10,
            children: [
              Expanded(
                child: CustomField(
                  controller: name,
                  icon: Icons.data_exploration_outlined,
                  hintText: "${getText('name')} ....",
                  labelText: getText('name'),
                  validator: (p0) {
                    return val(p0);
                  },
                ),
              ),
              CustomSelectImage(
                bytes: (p0) {
                  bytes = p0;
                },
              ),
            ],
          ),
        ],
      ),
    ),
    // ok action
    ok: () async {
      if (_formKey.currentState!.validate()) {
        waiting(context: context);
        final create = await DepartmentBase.add(name: name.text, image: bytes);
        pOP(context);
        if (create.success) {
          pOP(context);
          await msgDialog(context1: context, state: 1, text: create.msg);
          controller.addItem(create.data!);
        } else {
          msgDialog(context1: context, state: -1, text: create.msg);
        }
      }
    },
  );
}
