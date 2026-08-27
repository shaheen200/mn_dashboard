import 'package:flutter/material.dart';
import 'package:mn1/controller/application_controller.dart';
import 'package:mn1/database/user_base.dart';
import 'package:mn1/home/screens/clients/add/add_client_dialog.dart';
import 'package:mn1/home/screens/clients/show/show_client_view.dart';
import 'package:mn1/methods/page_size.dart';
import 'package:mn1/models/user.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/Custom_Table.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/custom_btn/customBtn.dart';
import 'package:mn1/tools/custom_field/custom_field.dart';

class ShowClient extends StatefulWidget {
  final bool add;
  const ShowClient({super.key, required this.add});

  @override
  State<ShowClient> createState() => _ShowClientState();
}

class _ShowClientState extends State<ShowClient> {
  late ApplicationController<User> controller;

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
        TEXT(text: getText('client'), size: 25, bold: true),
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
                      hintText: "${getText('phone')} ....",
                      onChanged: (p0) {
                        controller.search(p0, (p1) => p1.phone);
                      },
                    ),
                  ),
                ],
              ),
            ),
            CustomBtn(
              onClick: () {
                addClientDialog(context, controller: controller);
              },
              text: getText('create_client'),
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
                  CustomHeadTableItems(flex: 2, text: getText('phone')),
                  CustomHeadTableItems(flex: 2, text: getText('address')),
                  CustomHeadTableItems(flex: 2, text: getText('date')),
                  CustomHeadTableItems(flex: 1, text: getText('more')),
                ],
              ),
              Expanded(
                child: FutureBuilder(
                  future: UsersBase.getUsers(type: 'client'),
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
                      return ShowClientView(controller: controller);
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
