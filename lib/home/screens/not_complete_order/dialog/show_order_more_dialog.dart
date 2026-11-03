import 'package:flutter/material.dart';
import 'package:mn1/models/order.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/custom_dialog.dart';
import 'package:mn1/tools/custom_field/custom_field.dart';

void showOrderMoreDialog(BuildContext context, {required Order order}) {
  customDialog(
    context: context,
    width: 0.8,
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
                Icons.info_outline_rounded,
                color: Theme.of(context).primaryColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            TEXT(text: getText('order_data'), size: 20, bold: true),
          ],
        ),
        const SizedBox(height: 18),
        CustomField(
          controller: TextEditingController(text: order.extraAddress),
          icon: Icons.place_outlined,
          hintText: "${getText('extra_adress')} ....",
          labelText: getText('extra_adress'),
          enable: false,
        ),
        const SizedBox(height: 14),
        CustomField(
          controller: TextEditingController(text: order.extraPhone),
          icon: Icons.phone_android_rounded,
          hintText: "${getText('extra_phone')} ....",
          labelText: getText('extra_phone'),
          enable: false,
        ),
      ],
    ),
  );
}
