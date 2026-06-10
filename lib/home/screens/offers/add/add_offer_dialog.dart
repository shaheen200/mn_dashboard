import 'package:flutter/material.dart';
import 'package:mn1/database/offer_base.dart';
import 'package:mn1/methods/empty_value.dart';
import 'package:mn1/models/good.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/custom_dialog.dart';
import 'package:mn1/tools/custom_field/custom_field.dart';
import 'package:mn1/tools/msg_dialog.dart';
import 'package:mn1/tools/waiting.dart';

void addOfferDialog(BuildContext context, {required Good good}) {
  final TextEditingController price = .new();
  final TextEditingController title = .new();
  final TextEditingController descrip = .new();
  final TextEditingController fromDate = .new();
  final TextEditingController toDate = .new();
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
          TEXT(text: getText('add_offer'), size: 20, bold: true),
          Divider(
            color: Theme.of(context).primaryColorDark,
            height: 25,
            thickness: 2,
          ),

          Row(
            children: [
              Expanded(
                child: CustomField(
                  controller: title,
                  icon: Icons.text_fields_rounded,
                  hintText: "${getText('title')} ....",
                  labelText: getText('title'),
                  validator: (p0) {
                    return val(p0);
                  },
                ),
              ),
              Expanded(
                child: CustomField(
                  controller: descrip,
                  icon: Icons.numbers,
                  maxLength: 30,
                  hintText: "${getText('description')} ....",
                  labelText: getText('description'),
                  validator: (p0) {
                    return val(p0);
                  },
                ),
              ),
            ],
          ),
          CustomField(
            controller: price,
            icon: Icons.monetization_on,
            type: CustomFieldType.number,
            hintText: "${getText('offer_price')} ....",
            labelText: getText('offer_price'),
            validator: (p0) {
              return val(p0);
            },
          ),
          Row(
            children: [
              Expanded(
                child: CustomField(
                  controller: fromDate,
                  icon: Icons.date_range,
                  type: CustomFieldType.date,
                  hintText: "${getText('from')} ....",
                  labelText: getText('from'),
                  validator: (p0) {
                    return val(p0);
                  },
                ),
              ),
              Expanded(
                child: CustomField(
                  controller: toDate,
                  icon: Icons.monetization_on,
                  type: CustomFieldType.date,
                  hintText: "${getText('to')} ....",
                  labelText: getText('to'),
                  validator: (p0) {
                    return val(p0);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    // ok action
    ok: () async {
      if (_formKey.currentState!.validate()) {
        waiting(context: context);
        final create = await OfferBase.addOffer(
          descrption: descrip.text,
          goodId: good.id,
          price: price.text,
          title: title.text,
          fromDate: fromDate.text,
          toDate: toDate.text,
        );
        pOP(context);
        if (create.success) {
          pOP(context);
          await msgDialog(context1: context, state: 1, text: create.msg);
        } else {
          msgDialog(context1: context, state: -1, text: create.msg);
        }
      }
    },
  );
}
