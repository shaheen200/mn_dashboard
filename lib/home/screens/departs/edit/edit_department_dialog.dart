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

void editDepartDialog(
  BuildContext context, {
  required ApplicationController<Department> controller,
  required int index,
}) {
  final TextEditingController name = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Uint8List? bytes;

  name.text = controller.items[index].name;

  customDialog(
    context: context,
    width: 0.8,
    child: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.edit_rounded,
                  color: Theme.of(context).primaryColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              TEXT(
                text: getText('create_depart'),
                size: 20,
                bold: true,
                color: Theme.of(context).primaryColorDark,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: CustomField(
                  controller: name,
                  icon: Icons.data_exploration_outlined,
                  hintText: "${getText('name')} ....",
                  labelText: getText('name'),
                  validator: (p0) => val(p0),
                ),
              ),
              const SizedBox(width: 12),
              CustomSelectImage(
                initImage: controller.items[index].image,
                bytes: (p0) {
                  bytes = p0;
                },
              ),
            ],
          ),
        ],
      ),
    ),
    ok: () async {
      if (_formKey.currentState!.validate()) {
        waiting(context: context);
        final edit = await DepartmentBase.update(
          id: controller.items[index].id.toString(),
          name: name.text,
          image: bytes,
        );
        pOP(context);
        if (edit.success) {
          pOP(context);
          controller.editItem(edit.data!, (p0, p1) => p0.id == p1.id);
        } else {
          msgDialog(context1: context, state: -1, text: edit.msg);
        }
      }
    },
  );
}
