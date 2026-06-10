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
import 'package:mn1/tools/custom_image/select_list_image.dart';
import 'package:mn1/tools/msg_dialog.dart';
import 'package:mn1/tools/waiting.dart';

void addGoodDialog(
  BuildContext context, {
  required ApplicationController<Good> controller,
}) {
  final TextEditingController name = .new();
  final TextEditingController code = .new();
  final TextEditingController price = .new();
  final TextEditingController exist = .new();
  List<SelectListImageData> listImage = [];
  final GlobalKey<FormState> _formKey = .new();
  String departmentId = '';
  customDialog(
    context: context,
    width: 0.7,
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
                SelectListImage(listImage: listImage, selected: (listImage) {}),
              ],
            ),
          );
        }
      },
    ),
    // ok action
    ok: () async {
      if (_formKey.currentState!.validate()) {
        waiting(context: context);
        final add = await StoreBase.add(
          name: name.text,
          code: code.text,
          price: price.text,
          exist: exist.text,
          listImage: listImage,
          departmentId: departmentId,
        );
        pOP(context);
        if (add.success) {
          pOP(context);
          await msgDialog(context1: context, state: 1, text: add.msg);
          controller.addItem(add.data!);
        } else {
          msgDialog(context1: context, state: -1, text: add.msg);
        }
      }
    },
  );
}
