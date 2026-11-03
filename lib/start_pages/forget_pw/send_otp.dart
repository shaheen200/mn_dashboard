import 'package:flutter/material.dart';
import 'package:mn1/methods/empty_value.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/start_pages/forget_pw/verift_otp.dart';
import 'package:mn1/tools/container/custom_container.dart';
import 'package:mn1/tools/custom_btn/customBtn.dart';
import 'package:mn1/tools/custom_field/custom_field.dart';
import 'package:mn1/tools/custom_image/custom_image.dart';
import 'package:mn1/tools/funTool.dart';

class SendOtp extends StatefulWidget {
  const SendOtp({super.key});

  @override
  State<SendOtp> createState() => _SendOtpState();
}

class _SendOtpState extends State<SendOtp> {
  final TextEditingController phone = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(getText('forget_pw'))),
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
                    const CustomImage(path: 'image/pw.png', w: 0.3, h: 0.18),
                    const SizedBox(height: 20),
                    CustomField(
                      icon: Icons.phone_android_rounded,
                      controller: phone,
                      hintText: getText('phone'),
                      labelText: getText('phone'),
                      validator: (p0) => val(p0),
                    ),
                    const SizedBox(height: 30),
                    CustomBtn(
                      height: 52,
                      raduis: 16,
                      onClick: () async {
                        if (_formKey.currentState!.validate()) {
                          goPage(context, VeriftOtp(phone: phone.text));
                        }
                      },
                      text: getText('accept'),
                      w: 1,
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
