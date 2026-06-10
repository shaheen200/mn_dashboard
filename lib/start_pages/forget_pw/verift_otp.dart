import 'package:flutter/material.dart';
import 'package:mn1/methods/page_size.dart';
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
        child: CustomContainer(
          width: pageSizeWidth(context, 0.45),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImage(path: 'image/logo.png', w: 1, h: 0.2),
              CustomField(
                labelText: 'OTP',
                hintText: 'OTP',
                type: CustomFieldType.number,
                icon: Icons.key,
                onChanged: (p0) {
                  otp = p0;
                },
              ),
              const SizedBox(height: 15),
              TimerWidget(controller: _controller),
              TextButton(
                onPressed: () async {
                  // waiting(context: context);
                  // ApiData forget = await ForgetPwBase.reSendOtp(
                  //   phone: widget.phone,
                  // );
                  // pOP(context);
                  // if (forget.success) {
                  //   _controller.replay();
                  // } else {
                  //   msgDialog(context1: context, state: -1, text: forget.msg);
                  // }
                },
                child: TEXT(
                  color: Theme.of(context).primaryColor,
                  text: getText('send_again'),
                  size: 18,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              CustomBtn(
                onClick: () async {
                  goPage(context, Newpw(phone: widget.phone));
                  // waiting(context: context);
                  // ApiData accept = await ForgetPwBase.verifyOtp(
                  //     phone: widget.phone, otp: otp);
                  // pOP(context);
                  // if (accept.success) {
                  //   goPage(
                  //       context, Newpw(phone: widget.phone, emp: widget.emp));
                  // } else {
                  //   msgDialog(context1: context, state: -1, text: accept.msg);
                  // }
                },
                text: getText('accept'),
                w: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
