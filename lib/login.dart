import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/products.dart';
import 'package:my_app/bottom nav.dart';
import 'package:my_app/register.dart';
import 'package:my_app/questions.dart';
import 'package:my_app/values.dart';
import 'package:my_app/otp_verify.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isSendingOtp = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String _countryCode = '+91';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    final raw = _phoneController.text.trim().replaceAll(RegExp(r'[^\d]'), '');
    if (raw.length != 10) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'login_page.error_title'.tr(),
          message: 'login_page.invalid_phone'.tr(),
          contentType: ContentType.failure,
        ),
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
      return;
    }

    setState(() => _isSendingOtp = true);
    final fullPhone = '$_countryCode$raw';

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: fullPhone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          if (!mounted) return;
          setState(() => _isSendingOtp = false);
          await _auth.signInWithCredential(credential);
          final user = _auth.currentUser;
          if (user != null) await _navigateAfterAuth(user);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (mounted) setState(() => _isSendingOtp = false);
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'login_page.error_title'.tr(),
              message: e.message ?? 'login_page.generic_error_message'.tr(),
              contentType: ContentType.failure,
            ),
          );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        },
        codeSent: (String verificationId, int? resendToken) {
          if (!mounted) return;
          setState(() => _isSendingOtp = false);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerify(
                verificationId: verificationId,
                phoneNumber: fullPhone,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      if (mounted) setState(() => _isSendingOtp = false);
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'login_page.error_title'.tr(),
          message: e.toString(),
          contentType: ContentType.failure,
        ),
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  Future<void> _navigateAfterAuth(User user) async {
    final doc = await _firestore.collection('Users').doc(user.uid).get();
    if (doc.exists && doc.data() != null && (doc.data()!['crops'] as List?)?.isNotEmpty == true) {
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNav()));
      }
    } else {
      if (!doc.exists) {
        await _firestore.collection('Users').doc(user.uid).set({
          "name": "",
          "phone": user.phoneNumber?.replaceFirst('+91', '') ?? "",
          "crops": [],
          "soil_type": "",
          "irrigation_frequency": "",
          "irrigation_method": "",
          "land_size": "",
          "fertilizers": [],
          "equipments": [],
        });
      }
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Questions_(uid: user.uid)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('HI', style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w500)),
                SizedBox(width: 8),
                Switch(
                  value: context.locale.languageCode == 'en',
                  onChanged: (bool value) async {
                    final newLocale = value ? Locale('en') : Locale('hi');
                    await context.setLocale(newLocale);
                    if (mounted) setState(() {});
                  },
                  activeColor: themeColor,
                ),
                SizedBox(width: 8),
                Text('EN', style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Column(
                  children: [
                    Image.asset("assets/logo.png", width: 150, height: 150),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text('login_page.page_title'.tr(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: themeColor)),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'login_page.phone_label'.tr(),
                    hintText: 'login_page.phone_hint'.tr(),
                    counterText: '',
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: Icon(Icons.phone, color: themeColor),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: themeColor, width: 3),
                      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: themeColor, width: 3),
                      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: themeColor, width: 3),
                      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                child: ElevatedButton(
                  onPressed: _isSendingOtp ? null : _sendOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    disabledBackgroundColor: themeColor.withOpacity(0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    minimumSize: const Size(double.infinity, 50),
                    shadowColor: themeColor,
                    elevation: 5,
                  ),
                  child: _isSendingOtp
                      ? SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          'login_page.send_otp'.tr(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontFamily: "Cooper",
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey[400])),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'OR',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey[400])),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await _signInWithGoogle();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.grey[300]!, width: 1),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    minimumSize: const Size(double.infinity, 50),
                    elevation: 2,
                  ),
                  icon: Image.asset(
                    'assets/google.png',
                    height: 24,
                    width: 24,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey[300]!, width: 1),
                        ),
                        child: Center(
                          child: Text(
                            'G',
                            style: TextStyle(color: Colors.grey[700], fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
                  label: Text(
                    'login_page.sign_in_with_google'.tr(),
                    style: TextStyle(color: Colors.grey[800], fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "login_page.register_prompt".tr(),
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Register()));
                      },
                      child: Text(
                        "login_page.register_link".tr(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: themeColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(color: themeColor),
        ),
      );

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        if (mounted) Navigator.of(context).pop();
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final DocumentSnapshot doc = await _firestore.collection('Users').doc(user.uid).get();
        if (!doc.exists) {
          await _firestore.collection('Users').doc(user.uid).set({
            "name": user.displayName ?? "",
            "phone": "",
            "crops": [],
            "soil_type": "",
            "irrigation_frequency": "",
            "irrigation_method": "",
            "land_size": "",
            "fertilizers": [],
            "equipments": [],
          });
        }
        if (mounted) Navigator.of(context).pop();
        if (doc.exists && doc.data() != null) {
          if (mounted) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNav()));
          }
        } else {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Questions_(uid: user.uid)),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) Navigator.of(context).pop();
      if (mounted) {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'login_page.error_title'.tr(),
            message: 'Error signing in with Google: ${e.toString()}',
            contentType: ContentType.failure,
          ),
        );
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    }
  }
}
