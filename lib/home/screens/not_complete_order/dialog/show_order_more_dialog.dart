import 'package:flutter/material.dart';
import 'package:mn1/models/order.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/custom_dialog.dart';
import 'package:mn1/tools/custom_field/custom_field.dart';

void showOrderMoreDialog(BuildContext context, {required Order order}) {
  customDialog(
    context: context,
    width: 0.5,
    child: Column(
      crossAxisAlignment: .center,
      mainAxisAlignment: .start,
      mainAxisSize: .min,
      spacing: 15,
      children: [
        TEXT(text: getText('order_data'), size: 20, bold: true),
        Divider(
          color: Theme.of(context).primaryColorDark,
          height: 25,
          thickness: 2,
        ),

        CustomField(
          controller: TextEditingController(text: order.extraAddress),
          icon: Icons.place,
          hintText: "${getText('extra_adress')} ....",
          labelText: getText('extra_adress'),
          enable: false,
        ),
        CustomField(
          controller: TextEditingController(text: order.extraPhone),
          icon: Icons.call,
          hintText: "${getText('extra_phone')} ....",
          labelText: getText('extra_phone'),
          enable: false,
        ),
      ],
    ),
  );
}
