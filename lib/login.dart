import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_app/products.dart';
import 'package:my_app/bottom nav.dart';
import 'package:my_app/register.dart';
import 'package:my_app/values.dart';


class Login extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _LoginState();

  }

}

class _LoginState extends State<Login>{

  TextEditingController PhoneController=TextEditingController();
  TextEditingController PasswordController=TextEditingController();
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JeevanKhet',
        style: TextStyle(fontWeight: FontWeight.w700),),
          backgroundColor:  Color(0xFF969A2A),
          centerTitle: true,),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Log In'),
            SizedBox(height: 30),
            TextFormField(
              controller: PhoneController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              decoration: InputDecoration(
                labelText: ' Phone Number ',
                labelStyle: const TextStyle(
                  color: Colors.black, fontSize: 22, fontWeight: FontWeight.w500,
                ),
                prefixIcon: Icon(Icons.phone, color: themeColor,),
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
            SizedBox(height: 20),
            Stack(
              children: [
                TextFormField(
                  controller: PasswordController,
                  obscureText: isObscure,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: ' Password ',
                    labelStyle: const TextStyle(
                      color: Colors.black, fontSize: 22, fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: Icon(Icons.lock, color: themeColor,),
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
                Positioned(
                  right: 0,
                    child: IconButton(
                      onPressed: (){
                        setState(() {
                          isObscure=!isObscure;
                        });
                      },
                      icon: isObscure? Icon(FontAwesomeIcons.eye, color: themeColor, size: 20,):Icon(FontAwesomeIcons.eyeSlash, color: themeColor, size: 20,),
                    )
                )
              ],
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () async {
                if(PhoneController.text.length<10 || PasswordController.text.isEmpty){
                  const snackBar = SnackBar(
                    /// need to set following properties for best effect of awesome_snackbar_content
                    elevation: 0,
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    content: AwesomeSnackbarContent(
                      title: 'Error!',
                      message:
                      'Something went wrong try again',

                      /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                      contentType: ContentType.failure,
                    ),
                  );

                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(snackBar);
                }
                else{
                  try{
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: PhoneController.text+"@gmail.com",
                        password: PasswordController.text
                    );
                    print("Logged in!");
                  }
                  on FirebaseAuthException catch (e){
                    const snackBar = SnackBar(
                      /// need to set following properties for best effect of awesome_snackbar_content
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: 'Error!',
                        message:
                        'Something went wrong try again',

                        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                        contentType: ContentType.failure,
                      ),
                    );

                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(snackBar);
                  }
                }

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
                minimumSize: const Size(double.infinity, 50),
                // textStyle: TextStyle(fontSize: 14),
                shadowColor: themeColor,
                elevation: 5,
              ),
              child: const Text("Login",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: "Cooper",
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 50,),
            GestureDetector(
              child: Text("Don't have an account? Register"),
              onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Register()));
              },
            )
          ],
        ),
      ),
    );
  }
  
}