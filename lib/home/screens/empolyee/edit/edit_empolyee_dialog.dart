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
  final TextEditingController name = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController salary = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isActive = controller.items[index].isActive;
  name.text = controller.items[index].name;
  phone.text = controller.items[index].phone;
  address.text = controller.items[index].address;
  salary.text = controller.items[index].salary.toString();

  final bool isDesktop = MediaQuery.of(context).size.width > 900;

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
                text: getText('edit_emp'),
                size: 20,
                bold: true,
                color: Theme.of(context).primaryColorDark,
              ),
            ],
          ),
          const SizedBox(height: 18),

          if (isDesktop) ...[
            Row(
              children: [
                Expanded(child: _nameField(name)),
                const SizedBox(width: 14),
                Expanded(child: _phoneField(phone)),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: _addressField(address)),
                const SizedBox(width: 14),
                Expanded(child: _salaryField(salary)),
              ],
            ),
          ] else ...[
            _nameField(name),
            const SizedBox(height: 14),
            _phoneField(phone),
            const SizedBox(height: 14),
            _addressField(address),
            const SizedBox(height: 14),
            _salaryField(salary),
          ],
          const SizedBox(height: 16),
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

Widget _nameField(TextEditingController c) => CustomField(
  controller: c,
  icon: Icons.person_outline_rounded,
  hintText: "${getText('name')} ....",
  labelText: getText('name'),
  validator: (p0) => val(p0),
);

Widget _phoneField(TextEditingController c) => CustomField(
  controller: c,
  icon: Icons.phone_android_rounded,
  type: CustomFieldType.number,
  hintText: "${getText('phone')} ....",
  labelText: getText('phone'),
  validator: (p0) => val(p0),
);

Widget _addressField(TextEditingController c) => CustomField(
  controller: c,
  icon: Icons.place_outlined,
  hintText: "${getText('address')} ....",
  labelText: getText('address'),
  validator: (p0) => val(p0),
);

Widget _salaryField(TextEditingController c) => CustomField(
  controller: c,
  icon: Icons.monetization_on_outlined,
  type: CustomFieldType.number,
  hintText: "${getText('salary')} ....",
  labelText: getText('salary'),
  validator: (p0) => val(p0),
);
