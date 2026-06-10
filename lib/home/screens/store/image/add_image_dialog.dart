import 'package:flutter/material.dart';
import 'package:mn1/database/store_base.dart';
import 'package:mn1/models/good.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/custom_dialog.dart';
import 'package:mn1/tools/custom_image/select_list_image.dart';
import 'package:mn1/tools/msg_dialog.dart';
import 'package:mn1/tools/waiting.dart';

Future<void> addImageDialog({
  required BuildContext context,
  required Good good,
}) async {
  List<SelectListImageData> listImage = [];
  await customDialog(
    context: context,
    width: 0.6,
    child: Column(
      crossAxisAlignment: .center,
      mainAxisAlignment: .start,
      mainAxisSize: .min,
      spacing: 10,
      children: [
        TEXT(text: getText('add_image'), size: 20, bold: true),
        Divider(
          color: Theme.of(context).primaryColorDark,
          height: 25,
          thickness: 2,
        ),
        SelectListImage(listImage: listImage, selected: (listImage) {}),
      ],
    ),
    ok: () async {
      if (listImage.isNotEmpty) {
        waiting(context: context);
        final add = await StoreBase.addImage(
          id: good.id.toString(),
          listImage: listImage,
        );
        pOP(context);
        if (add.success) {
          pOP(context);
        } else {
          msgDialog(context1: context, state: -1, text: add.msg);
        }
      }
    },
  );
}
