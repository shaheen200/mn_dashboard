import 'package:flutter/material.dart';
import 'package:mn1/controller/application_controller.dart';
import 'package:mn1/database/store_base.dart';
import 'package:mn1/home/screens/store/add/add_good_dialog.dart';
import 'package:mn1/home/screens/store/show/show_store_view.dart';
import 'package:mn1/methods/page_size.dart';
import 'package:mn1/models/good.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/Custom_Table.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/custom_btn/customBtn.dart';
import 'package:mn1/tools/custom_field/custom_field.dart';

class ShowStore extends StatefulWidget {
  const ShowStore({super.key});

  @override
  State<ShowStore> createState() => _ShowStoreState();
}

class _ShowStoreState extends State<ShowStore> {
  late ApplicationController<Good> controller;

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
        TEXT(text: getText('store'), size: 25, bold: true),
        Row(
          mainAxisAlignment: .spaceBetween,
          crossAxisAlignment: .center,
          children: [
            SizedBox(
              width: pageSizeWidth(context, 0.5),
              child: Row(
                crossAxisAlignment: .center,
                spacing: 12,
                mainAxisAlignment: .start,
                children: [
                  Expanded(
                    child: CustomField(
                      icon: Icons.search,
                      hintText: "${getText('name')} ....",
                      onChanged: (p0) {
                        controller.search(p0, (p1) => p1.name);
                      },
                    ),
                  ),
                  Expanded(
                    child: CustomField(
                      icon: Icons.search,
                      hintText: "${getText('code')} ....",
                      onChanged: (p0) {
                        controller.search(p0, (p1) => p1.code.toString());
                      },
                    ),
                  ),
                ],
              ),
            ),
            CustomBtn(
              onClick: () {
                addGoodDialog(context, controller: controller);
              },
              text: getText('create_good'),
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
                  CustomHeadTableItems(flex: 4, text: getText('good_name')),
                  CustomHeadTableItems(flex: 2, text: getText('code')),
                  CustomHeadTableItems(flex: 2, text: getText('price')),
                  CustomHeadTableItems(flex: 2, text: getText('date')),
                  CustomHeadTableItems(flex: 2, text: getText('exist')),
                  CustomHeadTableItems(flex: 2, text: getText('state')),
                  CustomHeadTableItems(flex: 1, text: getText('more')),
                ],
              ),
              Expanded(
                child: FutureBuilder(
                  future: StoreBase.get(all: true),
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
                      return ShowStoreView(controller: controller);
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
