import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mn1/controller/application_controller.dart';
import 'package:mn1/database/banner_image_base.dart';
import 'package:mn1/models/image_banner.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/custom_dialog.dart';
import 'package:mn1/tools/custom_image/custom_select_file.dart';
import 'package:mn1/tools/msg_dialog.dart';
import 'package:mn1/tools/waiting.dart';

void addBannerImageDialog(
  BuildContext context, {
  required ApplicationController<ImageBanner> controller,
}) {
  PlatformFile? file;
  customDialog(
    context: context,
    width: 0.4,
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
                Icons.add_photo_alternate_rounded,
                color: Theme.of(context).primaryColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            TEXT(text: getText('add_image'), size: 20, bold: true),
          ],
        ),
        const SizedBox(height: 18),
        CustomSelectFile(
          onFileSelected: (p0) {
            file = p0;
          },
        ),
      ],
    ),
    ok: () async {
      waiting(context: context);
      final add = await BannerImageBase.add(image: file);
      pOP(context);
      if (add.success) {
        pOP(context);
        await msgDialog(context1: context, state: 1, text: add.msg);
        controller.addItem(add.data!);
      } else {
        msgDialog(context1: context, state: -1, text: add.msg);
      }
    },
  );
}
