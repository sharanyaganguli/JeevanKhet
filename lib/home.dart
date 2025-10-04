import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
        title: Text('JeevanKhet',
        style: TextStyle(fontWeight: FontWeight.w700),),
        backgroundColor:  Color(0xFF969A2A),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              SizedBox(height: 10),
              Text('Welcome',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),),
              SizedBox(height: 10),
              Image.asset('assets/farm icon.png'),
              SizedBox(height: 20),
              Text('What is our app?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
              SizedBox(height: 10),
              Text('🌱 Smarter Farming, Bigger Profits',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
              SizedBox(height: 10),
              Text('Our app helps you farm better using less water, the right crops, and fair prices. It shows you what to grow, how much to use, and how to sell at the best rate.',
              style: TextStyle(fontSize: 16), textAlign: TextAlign.center,),
              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 20),
              Text('🌱 Grow Your Plant, Grow a Habit',
                style: TextStyle(fontWeight: FontWeight.w600),),
              Text('Log each sustainable activity in your daily tracker.',
                textAlign: TextAlign.center,),
              SizedBox(height: 10),
              Image.asset('assets/plant game.png',
              width:150, height: 150, ),
              SizedBox(height: 20),
              Text('🌿 Watch It Thrive', 
              style: TextStyle(fontWeight: FontWeight.w600),),
              Text('Your plant grows a little more every time you choose sustainability.',
              textAlign: TextAlign.center,),
        
            ],
          ),
        ),
      ),
    );
  }
  
}

