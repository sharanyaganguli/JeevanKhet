import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:my_app/products.dart';
import 'package:my_app/values.dart';

class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _HomeState();

  }

}

class _HomeState extends State<Home>{
  User? user= FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (user_data.isEmpty){
      getUserInfo();
    }

  }
  getUserInfo() async {
    DocumentReference docRef =
    FirebaseFirestore.instance.collection("Users").doc(user?.uid);
    DocumentSnapshot snapshot = await docRef.get();
    if (snapshot.exists) {
      dynamic fieldValue = snapshot.data();
      if (fieldValue != null) {
        user_data = fieldValue;
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate("app_title"),
        style: TextStyle(fontWeight: FontWeight.w700),),
        backgroundColor:  Color(0xFF969A2A),
        // centerTitle: true,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.person))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              SizedBox(height: 10),
              Text(translate('home.welcome_message'),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),),
              SizedBox(height: 10),
              Image.asset('assets/farm icon.png'),
              SizedBox(height: 20),
              Text(translate('home.what_app.title'),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
              SizedBox(height: 10),
              Text('🌱 ${translate('home.what_app.sub_title')}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
              SizedBox(height: 10),
              Text( translate('home.what_app.para'),
              style: TextStyle(fontSize: 16), textAlign: TextAlign.center,),
              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 20),
              Text(translate('home.game.title'),
                style: TextStyle(fontWeight: FontWeight.w600),),
              Text('home.game.sub_title',
                textAlign: TextAlign.center,),
              SizedBox(height: 10),
              Image.asset('assets/plant game.png',
              width:150, height: 150, ),
              SizedBox(height: 20),


            ],
          ),
        ),
      ),
    );
  }
  
}

