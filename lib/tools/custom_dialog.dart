import 'package:flutter/material.dart';
import 'package:mn1/methods/page_size.dart';
import 'package:mn1/provider/language/get_text.dart';

import 'package:mn1/tools/container/custom_container.dart';
import 'package:mn1/tools/custom_btn/customBtn.dart';
import 'waiting.dart';

customDialog({
  required BuildContext context,
  required double width,
  double? height,
  required Widget child,
  void Function()? ok,
}) async {
  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return SimpleDialog(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        children: [
          CustomContainer(
            padding: const EdgeInsets.all(20),
            width: pageSizeWidth(context, width),
            height: height,
            child: Column(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                child,
                Row(
                  children: [
                    Expanded(
                      child: CustomBtn(
                        btnColor: Colors.red,
                        onClick: () {
                          pOP(context);
                        },
                        text: getText("cancel"),
                      ),
                    ),
                    Visibility(
                      visible: ok == null ? false : true,
                      child: const SizedBox(width: 10),
                    ),
                    Visibility(
                      visible: ok == null ? false : true,
                      child: Expanded(
                        child: CustomBtn(
                          btnColor: Colors.green,
                          onClick: ok,
                          text: getText("ok"),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
