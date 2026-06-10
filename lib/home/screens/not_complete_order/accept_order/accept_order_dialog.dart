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
  final TextEditingController note = .new();
  final GlobalKey<FormState> _formKey = .new();
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
          TEXT(text: getText('note'), size: 20, bold: true),
          Divider(
            color: Theme.of(context).primaryColorDark,
            height: 25,
            thickness: 2,
          ),

          CustomField(
            controller: note,
            icon: Icons.note,
            hintText: "${getText('note')} ....",
            labelText: getText('note'),
            validator: (p0) {
              return val(p0);
            },
          ),
        ],
      ),
    ),
    // ok action
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
        print(
          controller.items.map((e) {
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
