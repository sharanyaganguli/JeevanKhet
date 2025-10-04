// lib/register.dart
import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_app/login.dart';
import 'package:my_app/products.dart';
import 'package:my_app/bottom nav.dart';
import 'package:my_app/questions.dart';
import 'package:my_app/values.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterState();
  }
}

class _RegisterState extends State<Register> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  bool isObscure = true;
  bool isConfirmObscure = true;

  void showError(BuildContext context, String message) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Error!',
        message: message,
        contentType: ContentType.failure,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'JeevanKhet',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: const Color(0xFF969A2A),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('Register'),
            const SizedBox(height: 30),
            TextFormField(
              controller: nameController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
                prefixIcon: Icon(Icons.person, color: themeColor),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: themeColor, width: 3),
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: themeColor, width: 3),
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              decoration: InputDecoration(
                labelText: 'Phone Number',
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
              ),
            ),
            const SizedBox(height: 20),
            Stack(
              children: [
                TextFormField(
                  controller: passwordController,
                  obscureText: isObscure,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: Icon(Icons.lock, color: themeColor),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: themeColor, width: 3),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(10.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: themeColor, width: 3),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(10.0)),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                    icon: isObscure
                        ? Icon(
                        FontAwesomeIcons.eye, color: themeColor, size: 20)
                        : Icon(
                        FontAwesomeIcons.eyeSlash, color: themeColor, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Stack(
              children: [
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: isConfirmObscure,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: Icon(Icons.lock, color: themeColor),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: themeColor, width: 3),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(10.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: themeColor, width: 3),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(10.0)),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isConfirmObscure = !isConfirmObscure;
                      });
                    },
                    icon: isConfirmObscure
                        ? Icon(
                        FontAwesomeIcons.eye, color: themeColor, size: 20)
                        : Icon(
                        FontAwesomeIcons.eyeSlash, color: themeColor, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty ||
                    phoneController.text.length < 10 ||
                    passwordController.text.isEmpty ||
                    confirmPasswordController.text.isEmpty) {
                  showError(context, "Please fill all fields correctly");
                  return;
                }

                if (passwordController.text != confirmPasswordController.text) {
                  showError(context, "Passwords do not match");
                  return;
                }
                if (passwordController.text.length < 6 ||
                    confirmPasswordController.text.length < 6) {
                  showError(context, "Password needs to be atleast 6 digits");
                  return;
                }

                try {
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: "${phoneController.text}@gmail.com",
                    password: passwordController.text,
                  );

                  dynamic data={
                    "name": nameController.text,
                    "phone number": phoneController.text,
                    "crops": [],
                    "soil_type": "",
                    "irrigation_frequency": "",
                    "irrigation_method": "",
                    "land_size": "",
                    "fertilizers":[],
                    "equipments": [],
                  };
                  User? user=await FirebaseAuth.instance.currentUser;

                  await FirebaseFirestore.instance.collection("Users").doc(user?.uid).set(data);
                  
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Questions_(uid: user?.uid,)));

                  // Navigate or show success message
                } on FirebaseAuthException catch (_) {
                  showError(context, "Something went wrong, try again");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
                minimumSize: const Size(double.infinity, 50),
                shadowColor: themeColor,
                elevation: 5,
              ),
              child: const Text(
                "Register",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: "Cooper",
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 50),
            GestureDetector(
              child: const Text("Already have an account? Login"),
              onTap: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
            )
          ],
        ),
      ),
    );
  }
}