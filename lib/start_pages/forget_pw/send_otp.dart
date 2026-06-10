import 'package:flutter/material.dart';
import 'package:mn1/methods/empty_value.dart';
import 'package:mn1/methods/page_size.dart';
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
  final TextEditingController phone = .new();
  final GlobalKey<FormState> _formKey = .new();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(getText('forget_pw'))),
      body: Center(
        child: Form(
          key: _formKey,
          child: CustomContainer(
            width: pageSizeWidth(context, 0.45),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomImage(path: 'image/pw.png', w: 1, h: 0.2),
                CustomField(
                  icon: Icons.call,
                  controller: phone,
                  hintText: getText('phone'),
                  labelText: getText('phone'),
                  validator: (p0) {
                    return val(p0);
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                CustomBtn(
                  onClick: () async {
                    goPage(context, VeriftOtp(phone: phone.text));
                    // if (_formKey.currentState!.validate()) {
                    //   waiting(context: context);
                    //   ApiData accept = await ForgetPwBase.sendOtp(
                    //       phone: phone.text, emp: widget.emp);
                    //   pOP(context);
                    //   if (accept.success) {
                    //     goPage(context,
                    //         VeriftOtp(phone: phone.text));
                    //   } else {
                    //     msgDialog(
                    //         context1: context, state: -1, text: accept.msg);
                    //   }
                    // }
                  },
                  text: getText('accept'),
                  w: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
