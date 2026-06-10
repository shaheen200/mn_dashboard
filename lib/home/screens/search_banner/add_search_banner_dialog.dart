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
    width: 0.3,
    child: Column(
      mainAxisSize: .min,
      crossAxisAlignment: .center,
      children: [
        TEXT(text: getText('add_image'), size: 20, bold: true),
        Divider(
          color: Theme.of(context).primaryColorDark,
          height: 25,
          thickness: 2,
        ),
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
