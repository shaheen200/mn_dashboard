// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mn1/methods/empty_value.dart';
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
  final TextEditingController pw1 = TextEditingController();
  final TextEditingController pw2 = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(getText('change_password'))),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: CustomContainer(
                padding: const EdgeInsets.all(24),
                radius: 24,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CustomImage(path: "image/logo.png", w: 0.3, h: 0.18),
                    const SizedBox(height: 20),
                    CustomField(
                      controller: pw1,
                      labelText: getText('new_pw'),
                      hintText: getText('new_pw'),
                      pw: true,
                      validator: (p0) => val(p0),
                      icon: Icons.lock_outline_rounded,
                    ),
                    const SizedBox(height: 18),
                    CustomField(
                      controller: pw2,
                      labelText: getText('confirm_pw'),
                      hintText: getText('confirm_pw'),
                      pw: true,
                      validator: (p0) => val(p0),
                      icon: Icons.lock_outline_rounded,
                    ),
                    const SizedBox(height: 30),
                    CustomBtn(
                      height: 52,
                      raduis: 16,
                      onClick: () async {
                        if (_formKey.currentState!.validate()) {
                          // تنفيذ تغيير كلمة المرور
                        }
                      },
                      w: 1,
                      text: getText('change_password'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
