import 'package:flutter/material.dart';
import 'package:mn1/controller/application_controller.dart';
import 'package:mn1/database/department_base.dart';
import 'package:mn1/database/store_base.dart';
import 'package:mn1/methods/empty_value.dart';
import 'package:mn1/models/good.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/custom_dialog.dart';
import 'package:mn1/tools/custom_field/custom_drop_down.dart';
import 'package:mn1/tools/custom_field/custom_field.dart';
import 'package:mn1/tools/msg_dialog.dart';
import 'package:mn1/tools/waiting.dart';

void editGoodDialog(
  BuildContext context, {
  required ApplicationController<Good> controller,
  required int index,
}) {
  final TextEditingController name = .new();
  final TextEditingController code = .new();
  final TextEditingController price = .new();
  final TextEditingController exist = .new();
  final GlobalKey<FormState> _formKey = .new();
  String departmentId = '';

  name.text = controller.items[index].name;
  code.text = controller.items[index].code.toString();
  price.text = controller.items[index].price;
  exist.text = controller.items[index].exist;

  customDialog(
    context: context,
    width: 0.5,
    child: FutureBuilder(
      future: DepartmentBase.get(all: false),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (!snapshot.data!.success) {
          return Center(
            child: TEXT(
              text: snapshot.data!.msg,
              size: 20,
              bold: true,
              center: true,
            ),
          );
        } else {
          return Form(
            key: _formKey,
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

                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: CustomField(
                        controller: name,
                        icon: Icons.person,
                        hintText: "${getText('name')} ....",
                        labelText: getText('name'),
                        validator: (p0) {
                          return val(p0);
                        },
                      ),
                    ),
                    Expanded(
                      child: CustomField(
                        controller: code,
                        icon: Icons.numbers,
                        type: CustomFieldType.number,
                        hintText: "${getText('code')} ....",
                        labelText: getText('code'),
                        validator: (p0) {
                          return val(p0);
                        },
                      ),
                    ),
                  ],
                ),

                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: CustomField(
                        controller: price,
                        icon: Icons.monetization_on,
                        hintText: "${getText('price')} ....",
                        labelText: getText('price'),
                        validator: (p0) {
                          return val(p0);
                        },
                      ),
                    ),
                    Expanded(
                      child: CustomField(
                        controller: exist,
                        icon: Icons.numbers,
                        hintText: "${getText('exist')} ....",
                        labelText: getText('exist'),
                        validator: (p0) {
                          return val(p0);
                        },
                      ),
                    ),
                  ],
                ),
                CustomDropDown(
                  initValue:
                      snapshot.data!.data
                          .where(
                            (element) =>
                                element.id ==
                                controller.items[index].departmentId,
                          )
                          .toList()
                          .isNotEmpty
                      ? controller.items[index].departmentId.toString()
                      : null,
                  hintText: getText('department'),
                  labelText: getText('department'),
                  validator: (p0) {
                    return val(p0);
                  },
                  items: snapshot.data!.data.map((e) {
                    return CustomDropDownItems(
                      text: e.name,
                      value: e.id.toString(),
                    );
                  }).toList(),
                  onChanged: (p0) {
                    departmentId = p0;
                  },
                ),
              ],
            ),
          );
        }
      },
    ),
    // ok action
    ok: () async {
      waiting(context: context);
      final edit = await StoreBase.update(
        name: name.text,
        code: code.text,
        exist: exist.text,
        price: price.text,
        departmentId: departmentId,

        id: controller.items[index].id,
      );
      pOP(context);
      if (edit.success) {
        pOP(context);
        await msgDialog(context1: context, state: 1, text: edit.msg);
        controller.editItem(edit.data!, (p0, p1) => p0.id == p1.id);
      } else {
        msgDialog(context1: context, state: -1, text: edit.msg);
      }
    },
  );
}
