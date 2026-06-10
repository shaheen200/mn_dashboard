import 'package:flutter/material.dart';
import 'package:mn1/controller/application_controller.dart';
import 'package:mn1/database/department_base.dart';
import 'package:mn1/home/screens/departs/edit/edit_department_dialog.dart';
import 'package:mn1/home/screens/empolyee/get_by_id_dialog.dart';
import 'package:mn1/models/department.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/Custom_Table.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/msg_dialog.dart';
import 'package:mn1/tools/pop_menu/custom_pop.dart';
import 'package:mn1/tools/waiting.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowDepartView extends StatefulWidget {
  final ApplicationController<Department> controller;
  const ShowDepartView({super.key, required this.controller});

  @override
  State<ShowDepartView> createState() => _ShowDepartViewState();
}

class _ShowDepartViewState extends State<ShowDepartView> {
  @override
  void initState() {
    widget.controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.controller.items.length,
      itemBuilder: (context, index) {
        return CustomBodyTable(
          bodyData: [
            CustomBodyTableItems(
              flex: 1,
              widget: TEXT(text: "${index + 1}", bold: true, size: 17),
            ),
            CustomBodyTableItems(
              flex: 4,
              widget: TEXT(
                text: "${widget.controller.items[index].name}",
                bold: true,
                size: 16,
              ),
            ),
            CustomBodyTableItems(
              flex: 2,
              widget: GestureDetector(
                onTap: () async {
                  if ("${widget.controller.items[index].image}".isNotEmpty) {
                    final Uri _url = Uri.parse(
                      "${widget.controller.items[index].image}",
                    );
                    await launchUrl(_url);
                  }
                },
                child: TEXT(
                  color: Colors.blue,
                  text: getText('tap_to_view'),
                  bold: true,
                  size: 16,
                ),
              ),
            ),
            CustomBodyTableItems(
              flex: 2,
              widget: TEXT(
                text: "${widget.controller.items[index].time}",
                bold: true,
                size: 16,
              ),
            ),
            CustomBodyTableItems(
              flex: 2,
              widget: Switch(
                value: widget.controller.items[index].isActive,
                onChanged: (value) async {
                  waiting(context: context);
                  final create = await DepartmentBase.update(
                    id: widget.controller.items[index].id.toString(),
                    isActive: value.toString(),
                  );
                  pOP(context);
                  if (create.success) {
                    widget.controller.editItem(
                      create.data!,
                      (p0, p1) => p0.id == p1.id,
                    );
                  } else {
                    msgDialog(context1: context, state: -1, text: create.msg);
                  }
                },
              ),
            ),

            CustomBodyTableItems(
              flex: 1,
              widget: CustomPop(
                items: [
                  CustomPopItems(
                    text: getText('by'),
                    onTap: () {
                      byIdDialog(
                        context: context,
                        id: widget.controller.items[index].byId,
                      );
                    },
                  ),
                  CustomPopItems(
                    text: getText('edit'),
                    onTap: () {
                      editDepartDialog(
                        context,
                        controller: widget.controller,
                        index: index,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
