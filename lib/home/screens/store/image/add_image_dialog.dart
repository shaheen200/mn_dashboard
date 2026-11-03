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
                Icons.add_a_photo_rounded,
                color: Theme.of(context).primaryColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            TEXT(text: getText('add_image'), size: 20, bold: true),
          ],
        ),
        const SizedBox(height: 18),
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
