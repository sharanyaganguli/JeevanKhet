import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:my_app/Log.dart';
import 'package:my_app/bottom%20nav.dart';
import 'package:my_app/home.dart';
import 'package:my_app/login.dart';
import 'package:my_app/main%20advice.dart';
import 'package:my_app/products.dart';
import 'package:my_app/questions.dart';
import 'package:my_app/register.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var delegate = await LocalizationDelegate.create(
      fallbackLocale: 'en_US',
      supportedLocales: ['en_US', 'hi']);
  runApp(LocalizedApp(delegate, MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JeevanKhet',
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
    );
  }
}
class SplashScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }

}
class SplashScreenState extends State<SplashScreen>{

  User? user= FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // changeLocale(context, "hi");
    Timer(
      Duration(seconds: 5), () async {
      if (user == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      }
      else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => BottomNav()));
      }
    }
    );

  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: Center(
       child: Text(translate('app_title'))
     ),
   );
  }

}
