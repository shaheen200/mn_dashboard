// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mn1/methods/empty_value.dart';
import 'package:mn1/methods/page_size.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/container/custom_container.dart';
import 'package:mn1/tools/custom_btn/customBtn.dart';
import 'package:mn1/tools/custom_field/custom_field.dart';
import 'package:mn1/tools/custom_image/custom_image.dart';

class Newpw extends StatefulWidget {
  final String phone;
  const Newpw({super.key, required this.phone});

  @override
  State<Newpw> createState() => _NewpwState();
}

class _NewpwState extends State<Newpw> {
  final TextEditingController pw1 = .new();
  final TextEditingController pw2 = .new();
  final GlobalKey<FormState> _formKey = .new();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(getText('change_password'))),
      body: Form(
        key: _formKey,
        child: Center(
          child: CustomContainer(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              bottom: 30,
              top: 0,
            ),
            width: pageSizeWidth(context, 0.45),
            child: Column(
              spacing: 15,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomImage(path: "image/logo.png", w: 1, h: 0.2),
                CustomField(
                  controller: pw1,
                  labelText: getText('new_pw'),
                  hintText: getText('new_pw'),
                  pw: true,
                  validator: (p0) {
                    return val(p0);
                  },
                  icon: Icons.lock,
                ),
                CustomField(
                  controller: pw2,
                  labelText: getText('confirm_pw'),
                  hintText: getText('confirm_pw'),
                  pw: true,
                  validator: (p0) {
                    return val(p0);
                  },
                  icon: Icons.lock,
                ),
                CustomBtn(
                  onClick: () async {
                    // waiting(context: context);
                    // ApiData forget = await ForgetPwBase.newPw(
                    //     emp: widget.emp,
                    //     phone: widget.phone,
                    //     pw1: pw1.text,
                    //     pw2: pw2.text);
                    // pOP(context);
                    // if (forget.success) {
                    //   goToPage2(context, LoginPage());
                    // } else {
                    //   msgDialog(
                    //       context1: context, state: -1, text: forget.msg);
                    // }
                  },
                  w: 1,
                  text: getText('change_password'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
