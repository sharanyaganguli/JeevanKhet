import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:my_app/products.dart';
import 'package:my_app/main advice.dart';

class Soiladvisor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SoilAdvisorState();
  }
}

class _SoilAdvisorState extends State<Soiladvisor> {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('JeevanKhet',
            style: TextStyle(fontWeight: FontWeight.w700),),
          backgroundColor: Color(0xFF969A2A),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                    children: [
                      Text("Here's what best suited for your farm:",
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),)
                    ]
                )
            )
        )
    );
  }

}