import 'package:flutter/material.dart';
import 'package:mn1/methods/page_size.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/container/custom_container.dart';
import 'package:mn1/tools/custom_btn/customBtn.dart';
import 'waiting.dart';

Future<void> customDialog({
  required BuildContext context,
  required double width, // عرض الديالوج في الشاشات الكبيرة
  double? height,
  required Widget child,
  void Function()? ok,
}) async {
  final double screenWidth = MediaQuery.of(context).size.width;
  final bool isDesktop = screenWidth > 900;

  // ضبط العرض تلقائياً ليناسب الموبايل أو الويب
  final double responsiveWidth = isDesktop ? width : 0.92;

  await showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: '',
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return const SizedBox.shrink();
    },
    transitionBuilder: (context, animation, secondaryAnimation, childWidget) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutBack,
      );
      return ScaleTransition(
        scale: curvedAnimation,
        child: FadeTransition(
          opacity: animation,
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            contentPadding: EdgeInsets.zero,
            content: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: pageSizeWidth(context, responsiveWidth),
              ),
              child: CustomContainer(
                padding: const EdgeInsets.all(20),
                width: pageSizeWidth(context, responsiveWidth),
                height: height,
                radius: 24,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: child,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: CustomBtn(
                            height: 46,
                            raduis: 14,
                            btnColor: Colors.redAccent.shade700,
                            onClick: () {
                              pOP(context);
                            },
                            text: getText("cancel"),
                          ),
                        ),
                        Visibility(
                          visible: ok != null,
                          child: const SizedBox(width: 12),
                        ),
                        Visibility(
                          visible: ok != null,
                          child: Expanded(
                            child: CustomBtn(
                              height: 46,
                              raduis: 14,
                              btnColor: Colors.teal.shade700,
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
            ),
          ),
        ),
      );
    },
  );
}
