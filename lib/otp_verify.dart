import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/values.dart';
import 'package:my_app/bottom nav.dart';
import 'package:my_app/questions.dart';

class OtpVerify extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const OtpVerify({
    Key? key,
    required this.verificationId,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<OtpVerify> createState() => _OtpVerifyState();
}

class _OtpVerifyState extends State<OtpVerify> {
  final _pinController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isVerifying = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _showError(String message) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'login_page.error_title'.tr(),
        message: message,
        contentType: ContentType.failure,
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  Future<void> _verifyOtp() async {
    final code = _pinController.text.trim();
    if (code.length != 6) {
      _showError('otp_page.invalid_otp'.tr());
      return;
    }

    setState(() => _isVerifying = true);

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: code,
      );
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (!mounted) return;
      setState(() => _isVerifying = false);

      if (user == null) {
        _showError('otp_page.error_verification'.tr());
        return;
      }

      final doc = await _firestore.collection('Users').doc(user.uid).get();
      if (doc.exists && doc.data() != null && (doc.data()!['crops'] as List?)?.isNotEmpty == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNav()),
        );
      } else {
        if (!doc.exists) {
          await _firestore.collection('Users').doc(user.uid).set({
            "name": "",
            "phone": widget.phoneNumber.replaceFirst('+91', '').trim(),
            "crops": [],
            "soil_type": "",
            "irrigation_frequency": "",
            "irrigation_method": "",
            "land_size": "",
            "fertilizers": [],
            "equipments": [],
          });
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Questions_(uid: user.uid)),
        );
      }
    } catch (e) {
      if (mounted) setState(() => _isVerifying = false);
      _showError('otp_page.error_verification'.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    const defaultPinTheme = PinTheme(
      width: 52,
      height: 56,
      textStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Color(0xFF566017),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(12),
        // border: Border.all(color: Color(0xFF969A2A), width: 2),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: themeColor, width: 3),
        boxShadow: [
          BoxShadow(
            color: themeColor.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: lightThemeColor.withOpacity(0.15),
        border: Border.all(color: lightThemeColor, width: 2),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: themeColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 24),
              Text(
                'otp_page.title'.tr(),
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: themeColor,
                ),
              ),
              SizedBox(height: 12),
              Text(
                '${'otp_page.subtitle'.tr()} ${widget.phoneNumber}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 36),
              Pinput(
                controller: _pinController,
                focusNode: _focusNode,
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                keyboardType: TextInputType.number,
                autofocus: true,
                onCompleted: (pin) => _verifyOtp(),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isVerifying ? null : _verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  disabledBackgroundColor: themeColor.withOpacity(0.6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 52),
                  elevation: 5,
                ),
                child: _isVerifying
                    ? SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        'otp_page.verify'.tr(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
