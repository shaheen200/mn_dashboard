import 'package:flutter/material.dart';
import 'package:mn1/controller/application_controller.dart';
import 'package:mn1/home/screens/empolyee/edit/edit_empolyee_dialog.dart';
import 'package:mn1/home/screens/empolyee/get_by_id_dialog.dart';
import 'package:mn1/models/user.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/Custom_Table.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/pop_menu/custom_pop.dart';

class ShowEmpolyeeView extends StatefulWidget {
  final ApplicationController<User> controller;
  const ShowEmpolyeeView({super.key, required this.controller});

  @override
  State<ShowEmpolyeeView> createState() => _ShowEmpolyeeViewState();
}

class _ShowEmpolyeeViewState extends State<ShowEmpolyeeView> {
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
              widget: TEXT(
                text: "${widget.controller.items[index].phone}",
                bold: true,
                size: 16,
              ),
            ),
            CustomBodyTableItems(
              flex: 2,
              widget: TEXT(
                text: "${widget.controller.items[index].address}",
                bold: true,
                size: 16,
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
              widget: TEXT(
                text: "${widget.controller.items[index].salary}",
                bold: true,
                size: 16,
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
                      editEmpolyeeDialog(
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
