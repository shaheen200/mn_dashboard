import 'package:flutter/material.dart';
import 'package:mn1/controller/application_controller.dart';
import 'package:mn1/database/user_base.dart';
import 'package:mn1/methods/empty_value.dart';
import 'package:mn1/models/user.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/custom_dialog.dart';
import 'package:mn1/tools/custom_field/custom_field.dart';
import 'package:mn1/tools/custom_switch_btn/custom_switch_btn.dart';
import 'package:mn1/tools/msg_dialog.dart';
import 'package:mn1/tools/waiting.dart';

void editEmpolyeeDialog(
  BuildContext context, {
  required ApplicationController<User> controller,
  required int index,
}) {
  final TextEditingController name = .new();
  final TextEditingController phone = .new();
  final TextEditingController address = .new();
  final TextEditingController salary = .new();
  final GlobalKey<FormState> _formKey = .new();

  bool isActive = controller.items[index].isActive;
  name.text = controller.items[index].name;
  phone.text = controller.items[index].phone;
  address.text = controller.items[index].address;
  salary.text = controller.items[index].salary.toString();

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
          TEXT(text: getText('edit_emp'), size: 20, bold: true),
          Divider(
            color: Theme.of(context).primaryColorDark,
            height: 25,
            thickness: 2,
          ),

          Row(
            children: [
              Expanded(
                child: CustomField(
                  controller: name,
                  icon: Icons.person,
                  hintText: "${getText('name')} ....",
                  labelText: getText('name'),
                  validator: (p0) {
                    return val(p0);
                  },
                ),
              ),
              Expanded(
                child: CustomField(
                  controller: phone,
                  icon: Icons.phone,
                  type: CustomFieldType.number,
                  hintText: "${getText('phone')} ....",
                  labelText: getText('phone'),
                  validator: (p0) {
                    return val(p0);
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: CustomField(
                  controller: address,
                  icon: Icons.place,
                  hintText: "${getText('address')} ....",
                  labelText: getText('address'),
                  validator: (p0) {
                    return val(p0);
                  },
                ),
              ),
              Expanded(
                child: CustomField(
                  controller: salary,
                  icon: Icons.monetization_on,
                  type: CustomFieldType.number,
                  hintText: "${getText('salary')} ....",
                  labelText: getText('salary'),
                  validator: (p0) {
                    return val(p0);
                  },
                ),
              ),
            ],
          ),
          CustomSwitchBtn(
            text: getText('state'),
            value: isActive,
            onChanged: (p0) {
              isActive = p0;
            },
          ),
        ],
      ),
    ),
    // ok action
    ok: () async {
      waiting(context: context);
      final edit = await UsersBase.update(
        phone: phone.text,
        name: name.text,
        salary: salary.text,
        address: address.text,
        isActive: isActive.toString(),
        id: controller.items[index].id.toString(),
      );
      pOP(context);
      if (edit.success) {
        pOP(context);
        await msgDialog(context1: context, state: 1, text: edit.msg);
        controller.editItem(edit.data!, (p0, p1) => p0.id == p1.id);
      } else {
        msgDialog(context1: context, state: -1, text: edit.msg);
      }
    },
  );
}
