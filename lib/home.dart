import 'dart:async';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'account.dart';
import 'values.dart';

class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  User? user= FirebaseAuth.instance.currentUser;
  ui.Codec? _codec;
  ui.FrameInfo? _frameInfo;
  bool _isPlaying = true;
  
  @override
  void initState() {
    super.initState();
    if (user_data.isEmpty){
      getUserInfo();
    }
    _loadGif();
  }

  void _loadGif() async {
    final ByteData data = await rootBundle.load('assets/growing.gif');
    _codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    
    if (!mounted) return;
    
    // Decode all frames once and update UI
    for (int i = 0; i < _codec!.frameCount; i++) {
      final previousFrame = _frameInfo;
      _frameInfo = await _codec!.getNextFrame();
      
      if (mounted) {
        setState(() {
          // Update the displayed frame
        });
      }
      
      // Dispose previous frame to free memory
      previousFrame?.image.dispose();
      
      await Future.delayed(_frameInfo!.duration);
      
      if (!mounted) {
        _frameInfo?.image.dispose();
        return;
      }
    }
    
    // After one loop → stop GIF
    if (mounted) {
      setState(() {
        _isPlaying = false;
      });
    }
  }

  @override
  void dispose() {
    _codec?.dispose();
    _frameInfo?.image.dispose();
    super.dispose();
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
        title: Text("🌱 ${'app_title'.tr()}",
        style: TextStyle(fontWeight: FontWeight.w700),),
        backgroundColor:  Color(0xFF969A2A),
        // centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            Navigator.push(
              context, MaterialPageRoute(builder: (context) => const AccountPage()));
            }, icon: Icon(Icons.person))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              SizedBox(height: 10),
              Text('home.welcome_message'.tr(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),),
              SizedBox(height: 10),
              Image.asset('assets/farm icon.png'),
              SizedBox(height: 20),
              Text('home.what_app.title'.tr(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
              SizedBox(height: 10),
              Text('🌱 ${'home.what_app.sub_title'.tr()}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
              SizedBox(height: 10),
              Text('home.what_app.para'.tr(),
              style: TextStyle(fontSize: 16), textAlign: TextAlign.center,),
              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 20),
              Text('home.game.title'.tr(),
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
              SizedBox(height: 5,),
              Text('home.game.sub_title'.tr(),  style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,),
              SizedBox(height: 10),
              _isPlaying && _frameInfo != null
                  ? RawImage(
                      image: _frameInfo!.image, // show current frame during playback
                      width: 150,
                      height: 150,
                    )
                  : _frameInfo != null
                      ? RawImage(
                          image: _frameInfo!.image, // show final frame
                          width: 150,
                          height: 150,
                        )
                      : SizedBox(
                          width: 150,
                          height: 150,
                          child: Center(child: CircularProgressIndicator()),
                        ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
