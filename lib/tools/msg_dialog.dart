import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/custom_btn/customBtn.dart';
import 'customText.dart';

msgDialog({
  required BuildContext context1,
  required int state,
  required String text,
  void Function()? onClick,
}) async {
  final FocusNode _focusNode = FocusNode();
  _focusNode.requestFocus();
  await showDialog(
    context: context1,
    barrierDismissible: false,
    builder: (context) {
      return KeyboardListener(
        focusNode: _focusNode,
        onKeyEvent: (KeyEvent event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.enter) {
            Navigator.pop(context1);
            // _focusNode.dispose();
          }
        },
        child: SimpleDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context1).size.width * 0.25,
              decoration: BoxDecoration(
                color: Theme.of(context1).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    state == 1
                        ? Icons.done_all_rounded
                        : state == -1
                        ? Icons.close_rounded
                        : Icons.error_outline_rounded,
                    color: Theme.of(context).primaryColorDark,
                    size: 100,
                  ),

                  const SizedBox(height: 10),
                  TEXT(
                    text: text,
                    size: 18,
                    bold: true,
                    center: true,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: CustomBtn(
                          btnColor: Colors.red,
                          w: 0.115,
                          onClick: () {
                            Navigator.pop(context1);
                          },
                          text: getText("cancel"),
                        ),
                      ),
                      Visibility(
                        visible: onClick == null ? false : true,
                        child: const SizedBox(width: 10),
                      ),
                      Visibility(
                        visible: onClick == null ? false : true,
                        child: Expanded(
                          child: CustomBtn(
                            btnColor: Colors.green,
                            onClick: onClick,
                            w: 0.115,
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
        ),
      );
    },
  );
}
