import 'package:flutter/material.dart';
import 'package:mn1/controller/application_controller.dart';
import 'package:mn1/models/order.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/custom_dialog.dart';
import 'package:mn1/tools/custom_field/custom_field.dart';

void completeOrderMoreDialog(
  BuildContext context, {
  required ApplicationController<Order> controller,
  required int index,
}) {
  customDialog(
    context: context,
    width: 0.7,
    child: Column(
      crossAxisAlignment: .center,
      mainAxisAlignment: .start,
      mainAxisSize: .min,
      spacing: 15,
      children: [
        TEXT(text: getText('create_good'), size: 20, bold: true),
        Divider(
          color: Theme.of(context).primaryColorDark,
          height: 25,
          thickness: 2,
        ),

        CustomField(
          controller: TextEditingController(text: controller.items[index].note),
          icon: Icons.note,
          hintText: "${getText('note')} ....",
          labelText: getText('note'),
          maxLines: 5,
          enable: false,
        ),
      ],
    ),
  );
}
