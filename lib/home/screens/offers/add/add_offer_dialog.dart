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
  final TextEditingController price = TextEditingController();
  final TextEditingController title = TextEditingController();
  final TextEditingController descrip = TextEditingController();
  final TextEditingController fromDate = TextEditingController();
  final TextEditingController toDate = TextEditingController();
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
                  Icons.local_offer_rounded,
                  color: Theme.of(context).primaryColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              TEXT(text: getText('add_offer'), size: 20, bold: true),
            ],
          ),
          const SizedBox(height: 18),
          if (isDesktop) ...[
            Row(
              children: [
                Expanded(child: _titleField(title)),
                const SizedBox(width: 12),
                Expanded(child: _descripField(descrip)),
              ],
            ),
            const SizedBox(height: 12),
            _priceField(price),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _fromDateField(fromDate)),
                const SizedBox(width: 12),
                Expanded(child: _toDateField(toDate)),
              ],
            ),
          ] else ...[
            _titleField(title),
            const SizedBox(height: 12),
            _descripField(descrip),
            const SizedBox(height: 12),
            _priceField(price),
            const SizedBox(height: 12),
            _fromDateField(fromDate),
            const SizedBox(height: 12),
            _toDateField(toDate),
          ],
        ],
      ),
    ),
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

Widget _titleField(TextEditingController c) => CustomField(
  controller: c,
  icon: Icons.text_fields_rounded,
  hintText: "${getText('title')} ....",
  labelText: getText('title'),
  validator: (p0) => val(p0),
);

Widget _descripField(TextEditingController c) => CustomField(
  controller: c,
  icon: Icons.description_rounded,
  maxLength: 30,
  hintText: "${getText('description')} ....",
  labelText: getText('description'),
  validator: (p0) => val(p0),
);

Widget _priceField(TextEditingController c) => CustomField(
  controller: c,
  icon: Icons.monetization_on_outlined,
  type: CustomFieldType.number,
  hintText: "${getText('offer_price')} ....",
  labelText: getText('offer_price'),
  validator: (p0) => val(p0),
);

Widget _fromDateField(TextEditingController c) => CustomField(
  controller: c,
  icon: Icons.date_range_rounded,
  type: CustomFieldType.date,
  hintText: "${getText('from')} ....",
  labelText: getText('from'),
  validator: (p0) => val(p0),
);

Widget _toDateField(TextEditingController c) => CustomField(
  controller: c,
  icon: Icons.date_range_rounded,
  type: CustomFieldType.date,
  hintText: "${getText('to')} ....",
  labelText: getText('to'),
  validator: (p0) => val(p0),
);
