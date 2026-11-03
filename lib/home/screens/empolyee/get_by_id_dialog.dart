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
      width: 0.45,
      child: Column(
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
                  Icons.badge_rounded,
                  color: Theme.of(context).primaryColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              TEXT(
                text: getText('user_data'),
                size: 20,
                bold: true,
                color: Theme.of(context).primaryColorDark,
              ),
            ],
          ),
          const SizedBox(height: 18),
          CustomField(
            controller: TextEditingController(text: user.data!.name),
            enable: false,
            icon: Icons.person_outline_rounded,
            hintText: "${getText('name')} ....",
            labelText: getText('name'),
          ),
          const SizedBox(height: 14),
          CustomField(
            controller: TextEditingController(text: user.data!.phone),
            enable: false,
            icon: Icons.phone_android_rounded,
            type: CustomFieldType.number,
            hintText: "${getText('phone')} ....",
            labelText: getText('phone'),
          ),
          const SizedBox(height: 14),
          CustomField(
            controller: TextEditingController(text: user.data!.address),
            enable: false,
            icon: Icons.place_outlined,
            hintText: "${getText('address')} ....",
            labelText: getText('address'),
          ),
        ],
      ),
    );
  }
}
