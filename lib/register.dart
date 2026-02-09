// lib/register.dart
// With phone authentication, sign-up and sign-in use the same flow.
// This screen redirects to Login where users enter phone and verify OTP.

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_app/login.dart';
import 'package:my_app/values.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterState();
  }
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: themeColor),
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login())),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              SizedBox(height: 40),
              Image.asset("assets/logo.png", width: 120, height: 120),
              SizedBox(height: 32),
              Text(
                'register_page.page_title'.tr(),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: themeColor),
              ),
              SizedBox(height: 16),
              Text(
                context.locale.languageCode == 'hi'
                    ? 'नया अकाउंट बनाने के लिए लॉग इन पेज पर जाएं और अपना फोन नंबर डालकर OTP से सत्यापित करें।'
                    : 'To create an account, go to the login screen and verify with your phone number using OTP.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[700], height: 1.4),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  minimumSize: const Size(double.infinity, 50),
                  elevation: 5,
                ),
                child: Text(
                  "register_page.login_link".tr(),
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
