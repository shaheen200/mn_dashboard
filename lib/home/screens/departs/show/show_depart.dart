import 'package:flutter/material.dart';
import 'package:mn1/controller/application_controller.dart';
import 'package:mn1/database/department_base.dart';
import 'package:mn1/home/screens/departs/add/add_depart_dialog.dart';
import 'package:mn1/home/screens/departs/show/show_depart_view.dart';
import 'package:mn1/methods/page_size.dart';
import 'package:mn1/models/department.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/Custom_Table.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/custom_btn/customBtn.dart';
import 'package:mn1/tools/custom_field/custom_field.dart';

class ShowDepart extends StatefulWidget {
  const ShowDepart({super.key});

  @override
  State<ShowDepart> createState() => _ShowDepartState();
}

class _ShowDepartState extends State<ShowDepart> {
  late ApplicationController<Department> controller;

  @override
  void initState() {
    controller = .new();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      spacing: 20,
      children: [
        TEXT(text: getText('depart'), size: 25, bold: true),
        Row(
          mainAxisAlignment: .spaceBetween,
          crossAxisAlignment: .center,
          children: [
            SizedBox(
              width: pageSizeWidth(context, 0.4),
              child: CustomField(
                icon: Icons.search,
                hintText: "${getText('name')} ....",
                onChanged: (p0) {
                  controller.search(p0, (p1) => p1.name);
                },
              ),
            ),
            CustomBtn(
              onClick: () {
                addDepartDialog(context, controller: controller);
              },
              text: getText('create_depart'),
              w: 0.2,
            ),
          ],
        ),
        Expanded(
          child: Column(
            children: [
              CustomHeadTable(
                headData: [
                  CustomHeadTableItems(flex: 1, text: getText('num')),
                  CustomHeadTableItems(flex: 4, text: getText('name')),
                  CustomHeadTableItems(flex: 2, text: getText('image')),
                  CustomHeadTableItems(flex: 2, text: getText('date')),
                  CustomHeadTableItems(flex: 2, text: getText('state')),
                  CustomHeadTableItems(flex: 1, text: getText('more')),
                ],
              ),
              Expanded(
                child: FutureBuilder(
                  future: DepartmentBase.get(all: true),
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
                      controller.equal(snapshot.data!.data);
                      return ShowDepartView(controller: controller);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
