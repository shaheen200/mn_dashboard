import 'package:flutter/material.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/start_pages/forget_pw/new_pw.dart';
import 'package:mn1/tools/container/custom_container.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/custom_btn/customBtn.dart';
import 'package:mn1/tools/custom_field/custom_field.dart';
import 'package:mn1/tools/custom_image/custom_image.dart';
import 'package:mn1/tools/funTool.dart';
import 'package:mn1/tools/timer/timer_widget.dart';

class VeriftOtp extends StatefulWidget {
  final String phone;
  const VeriftOtp({super.key, required this.phone});

  @override
  State<VeriftOtp> createState() => _VeriftOtpState();
}

class _VeriftOtpState extends State<VeriftOtp> {
  String otp = '';
  late TimerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TimerController(initialSeconds: 120, autoIncrease: false);
    _controller.start();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(getText('verify_otp'))),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: CustomContainer(
              padding: const EdgeInsets.all(24),
              radius: 24,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CustomImage(path: 'image/logo.png', w: 0.3, h: 0.18),
                  const SizedBox(height: 20),
                  CustomField(
                    labelText: 'OTP',
                    hintText: 'OTP',
                    type: CustomFieldType.number,
                    icon: Icons.key_rounded,
                    onChanged: (p0) {
                      otp = p0;
                    },
                  ),
                  const SizedBox(height: 20),
                  TimerWidget(controller: _controller),
                  TextButton(
                    onPressed: () {
                      _controller.replay();
                    },
                    child: TEXT(
                      color: Theme.of(context).primaryColor,
                      text: getText('send_again'),
                      size: 16,
                      bold: true,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomBtn(
                    height: 52,
                    raduis: 16,
                    onClick: () async {
                      goPage(context, Newpw(phone: widget.phone));
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
    );
  }
}
