import 'package:flutter/material.dart';
import 'package:mn1/controller/application_controller.dart';
import 'package:mn1/database/user_base.dart';
import 'package:mn1/methods/empty_value.dart';
import 'package:mn1/models/user.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/custom_dialog.dart';
import 'package:mn1/tools/custom_field/custom_field.dart';
import 'package:mn1/tools/msg_dialog.dart';
import 'package:mn1/tools/waiting.dart';

void addClientDialog(
  BuildContext context, {
  required ApplicationController<User> controller,
}) {
  final TextEditingController name = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController pw = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                  Icons.person_add_rounded,
                  color: Theme.of(context).primaryColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              TEXT(
                text: getText('create_client'),
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
            _addressField(address),
          ] else ...[
            _nameField(name),
            const SizedBox(height: 14),
            _phoneField(phone),
            const SizedBox(height: 14),
            _addressField(address),
          ],
          const SizedBox(height: 14),
          CustomField(
            controller: pw,
            icon: Icons.lock_outline_rounded,
            type: CustomFieldType.text,
            pw: true,
            hintText: "${getText('pw')} ....",
            labelText: getText('pw'),
            validator: (p0) => val(p0),
          ),
        ],
      ),
    ),
    ok: () async {
      if (_formKey.currentState!.validate()) {
        waiting(context: context);
        final create = await UsersBase.add(
          phone: phone.text,
          name: name.text,
          pw: pw.text,
          role: 'client',
          salary: "0",
          profileImage: '',
          address: address.text,
        );
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
