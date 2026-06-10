import 'package:flutter/material.dart';
import 'package:mn1/database/user_base.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/custom_dialog.dart';
import 'package:mn1/tools/custom_field/custom_field.dart';
import 'package:mn1/tools/msg_dialog.dart';
import 'package:mn1/tools/waiting.dart';

Future<void> byIdDialog({
  required BuildContext context,
  required int id,
}) async {
  waiting(context: context);
  final user = await UsersBase.getById(id: id);
  pOP(context);
  if (!user.success) {
    msgDialog(context1: context, state: -1, text: user.msg);
  } else {
    customDialog(
      context: context,
      width: 0.5,
      child: Column(
        mainAxisSize: .min,
        children: [
          TEXT(text: getText('user_data'), size: 20, bold: true),
          Divider(
            color: Theme.of(context).primaryColorDark,
            height: 25,
            thickness: 2,
          ),

          CustomField(
            controller: TextEditingController(text: user.data!.name),
            enable: false,
            icon: Icons.person,
            hintText: "${getText('name')} ....",
            labelText: getText('name'),
          ),
          CustomField(
            controller: TextEditingController(text: user.data!.phone),
            enable: false,
            icon: Icons.phone,
            type: CustomFieldType.number,
            hintText: "${getText('phone')} ....",
            labelText: getText('phone'),
          ),
          CustomField(
            controller: TextEditingController(text: user.data!.address),
            enable: false,
            icon: Icons.place,
            hintText: "${getText('address')} ....",
            labelText: getText('address'),
          ),
        ],
      ),
    );
  }
}
