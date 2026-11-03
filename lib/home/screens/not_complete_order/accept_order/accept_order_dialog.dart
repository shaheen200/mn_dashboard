import 'package:flutter/material.dart';
import 'package:mn1/controller/application_controller.dart';
import 'package:mn1/database/order_base.dart';
import 'package:mn1/methods/empty_value.dart';
import 'package:mn1/models/order.dart';
import 'package:mn1/models/order_good.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/custom_dialog.dart';
import 'package:mn1/tools/custom_field/custom_field.dart';
import 'package:mn1/tools/msg_dialog.dart';
import 'package:mn1/tools/waiting.dart';

void acceptOrderDialog(
  BuildContext context, {
  required String status,
  required ApplicationController<OrderGood> controller,
  required ApplicationController<Order> orderController,
  required int indexOrder,
}) {
  final TextEditingController note = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
            controller: note,
            icon: Icons.note_rounded,
            hintText: "${getText('note')} ....",
            labelText: getText('note'),
            validator: (p0) => val(p0),
          ),
        ],
      ),
    ),
    ok: () async {
      if (_formKey.currentState!.validate()) {
        waiting(context: context);
        final create = await OrderBase.acceptOrder(
          note: note.text,
          orderId: orderController.items[indexOrder].id,
          status: status,
          listData: controller.items.map((e) {
            return {'good_id': e.goodId, 'price': e.price, 'count': e.count};
          }).toList(),
        );
        pOP(context);
        if (create.success) {
          pOP(context);
          await msgDialog(context1: context, state: 1, text: create.msg);
          orderController.delete(indexOrder);
          pOP(context);
        } else {
          msgDialog(context1: context, state: -1, text: create.msg);
        }
      }
    },
  );
}
