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
  final FocusNode focusNode = FocusNode();
  focusNode.requestFocus();
  await showDialog(
    context: context1,
    barrierDismissible: false,
    builder: (context) {
      return KeyboardListener(
        focusNode: focusNode,
        onKeyEvent: (KeyEvent event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.enter) {
            Navigator.pop(context1);
          }
        },
        child: SimpleDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                width: MediaQuery.of(context1).size.width * 0.3,
                constraints: const BoxConstraints(maxWidth: 400),
                decoration: BoxDecoration(
                  color: Theme.of(context1).cardColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color:
                            (state == 1
                                    ? Colors.green
                                    : state == -1
                                    ? Colors.red
                                    : Colors.orange)
                                .withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        state == 1
                            ? Icons.done_all_rounded
                            : state == -1
                            ? Icons.close_rounded
                            : Icons.error_outline_rounded,
                        color: state == 1
                            ? Colors.green
                            : state == -1
                            ? Colors.red
                            : Colors.orange,
                        size: 56,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TEXT(
                      text: text,
                      size: 17,
                      bold: true,
                      center: true,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CustomBtn(
                            height: 46,
                            raduis: 14,
                            btnColor: Colors.redAccent.shade700,
                            onClick: () {
                              Navigator.pop(context1);
                            },
                            text: getText("cancel"),
                          ),
                        ),
                        Visibility(
                          visible: onClick != null,
                          child: const SizedBox(width: 12),
                        ),
                        Visibility(
                          visible: onClick != null,
                          child: Expanded(
                            child: CustomBtn(
                              height: 46,
                              raduis: 14,
                              btnColor: Colors.teal.shade700,
                              onClick: onClick,
                              text: getText("ok"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
