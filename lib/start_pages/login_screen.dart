// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:mn1/database/user_base.dart';
import 'package:mn1/home/home_page.dart';
import 'package:mn1/methods/empty_value.dart';
import 'package:mn1/methods/page_size.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/start_pages/forget_pw/send_otp.dart';
import 'package:mn1/tools/container/custom_container.dart';
import 'package:mn1/tools/custom_btn/customBtn.dart';
import 'package:mn1/tools/custom_field/custom_field.dart';
import 'package:mn1/tools/custom_image/custom_image.dart';
import 'package:mn1/tools/funTool.dart';
import 'package:mn1/tools/msg_dialog.dart';
import 'package:mn1/tools/waiting.dart';
import '../tools/customText.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phone = .new();
  final TextEditingController pw = .new();
  final GlobalKey<FormState> formKey = .new();

  // @override
  // void initState() {
  //   phone.text = '9661030015864';
  //   pw.text = '123654';
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Form(
            key: formKey,
            child: CustomContainer(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                bottom: 30,
                top: 0,
              ),
              width: pageSizeWidth(context, 0.4),
              child: Column(
                spacing: 15,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 25),
                  CustomField(
                    labelText: getText("phone"),
                    hintText: getText("phone"),
                    icon: Icons.phone,
                    controller: phone,
                    type: CustomFieldType.number,
                    validator: (p0) {
                      return val(p0);
                    },
                  ),
                  CustomField(
                    labelText: getText("pw"),
                    hintText: getText("pw"),
                    icon: Icons.lock,
                    pw: true,
                    controller: pw,
                    validator: (p0) {
                      return val(p0);
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      goPage(context, SendOtp());
                    },
                    child: TEXT(
                      text: getText('forget_pw'),
                      size: 18,
                      bold: true,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                  CustomBtn(
                    height: 55,
                    raduis: 25,
                    w: 1,
                    onClick: () async {
                      if (formKey.currentState!.validate()) {
                        waiting(context: context);
                        final login = await UsersBase.login(
                          phone: phone.text,
                          pw: pw.text,
                        );
                        pOP(context);
                        if (login.success) {
                          goToPage(context, HomePage(id: login.data));
                        } else {
                          msgDialog(
                            context1: context,
                            state: -1,
                            text: login.msg,
                          );
                        }
                      }
                    },
                    text: getText("login"),
                  ),
                ],
              ),
            ),
          ),
          const CustomImage(path: "image/logo.png", w: 0.4, h: 1),
        ],
      ),
    );
  }
}
