// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:mn1/methods/page_size.dart';
import 'package:mn1/tools/custom_dialog.dart';
import 'package:mn1/tools/custom_image/custom_file_image.dart';
import 'package:mn1/tools/custom_image/custom_image.dart';
import 'package:mn1/tools/custom_image/custom_memory_image.dart';

enum ShowImageDialogType { network, file, assets, memory }

showImageDialog(
  BuildContext context, {
  required ShowImageDialogType type,
  required var url,
}) {
  customDialog(
    context: context,
    width: 0.8,
    child: type == ShowImageDialogType.network
        ? Image.network(
            url.replaceAll('http://10.0.2.2:8084', 'http://localhost:8084'),
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.7,
            filterQuality: FilterQuality.high,
            errorBuilder: (context, error, stackTrace) {
              return CustomImage(
                path: 'image/logo.png',
                w: pageSizeWidth(context, 0.8),
                h: pageSizeHeight(context, 0.7),
              );
            },
            fit: BoxFit.contain,
          )
        : type == ShowImageDialogType.assets
        ? CustomImage(path: url, w: 0.8, h: 0.7)
        : type == ShowImageDialogType.file
        ? CustomFileImage(
            path: url,
            w: pageSizeWidth(context, 0.8),
            h: pageSizeHeight(context, 0.7),
          )
        : CustomMemoryImage(
            bytes: url,
            w: pageSizeWidth(context, 0.8),
            h: pageSizeHeight(context, 0.7),
          ),
  );
}
