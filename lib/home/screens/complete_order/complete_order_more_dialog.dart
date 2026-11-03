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
                Icons.note_alt_rounded,
                color: Theme.of(context).primaryColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            TEXT(text: getText('note'), size: 20, bold: true),
          ],
        ),
        const SizedBox(height: 18),
        CustomField(
          controller: TextEditingController(text: controller.items[index].note),
          icon: Icons.note_rounded,
          hintText: "${getText('note')} ....",
          labelText: getText('note'),
          maxLines: 5,
          enable: false,
        ),
      ],
    ),
  );
}
