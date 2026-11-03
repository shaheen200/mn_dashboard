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
  final TextEditingController name = TextEditingController();
  final TextEditingController code = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController exist = TextEditingController();
  List<SelectListImageData> listImage = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String departmentId = '';

  final bool isDesktop = MediaQuery.of(context).size.width > 900;

  customDialog(
    context: context,
    width: 0.6,
    child: FutureBuilder(
      future: DepartmentBase.get(all: false),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError ||
            !snapshot.hasData ||
            !snapshot.data!.success) {
          return Center(
            child: TEXT(
              text: snapshot.data?.msg ?? "حدث خطأ في تحميل الأقسام",
              size: 18,
              bold: true,
              center: true,
            ),
          );
        } else {
          return Form(
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
                        Icons.add_box_rounded,
                        color: Theme.of(context).primaryColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    TEXT(text: getText('create_good'), size: 20, bold: true),
                  ],
                ),
                const SizedBox(height: 18),
                if (isDesktop) ...[
                  Row(
                    children: [
                      Expanded(child: _nameField(name)),
                      const SizedBox(width: 12),
                      Expanded(child: _codeField(code)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _priceField(price)),
                      const SizedBox(width: 12),
                      Expanded(child: _existField(exist)),
                    ],
                  ),
                ] else ...[
                  _nameField(name),
                  const SizedBox(height: 12),
                  _codeField(code),
                  const SizedBox(height: 12),
                  _priceField(price),
                  const SizedBox(height: 12),
                  _existField(exist),
                ],
                const SizedBox(height: 12),
                CustomDropDown(
                  hintText: getText('department'),
                  labelText: getText('department'),
                  validator: (p0) => val(p0),
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
                const SizedBox(height: 12),
                SelectListImage(listImage: listImage, selected: (listImage) {}),
              ],
            ),
          );
        }
      },
    ),
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

Widget _nameField(TextEditingController c) => CustomField(
  controller: c,
  icon: Icons.inventory_2_outlined,
  hintText: "${getText('name')} ....",
  labelText: getText('name'),
  validator: (p0) => val(p0),
);

Widget _codeField(TextEditingController c) => CustomField(
  controller: c,
  icon: Icons.qr_code_rounded,
  type: CustomFieldType.number,
  hintText: "${getText('code')} ....",
  labelText: getText('code'),
  validator: (p0) => val(p0),
);

Widget _priceField(TextEditingController c) => CustomField(
  controller: c,
  icon: Icons.monetization_on_outlined,
  hintText: "${getText('price')} ....",
  labelText: getText('price'),
  validator: (p0) => val(p0),
);

Widget _existField(TextEditingController c) => CustomField(
  controller: c,
  icon: Icons.format_list_numbered_rounded,
  hintText: "${getText('exist')} ....",
  labelText: getText('exist'),
  validator: (p0) => val(p0),
);
