import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:my_app/products.dart';
import 'package:my_app/main advice.dart';
import 'package:my_app/teaching_flow.dart';
import 'package:my_app/values.dart';

class TeachingDetails extends StatefulWidget {
  String title;
  TeachingDetails(this.title);
  @override
  State<StatefulWidget> createState() {
    return _TeachingDetailsState();

  }
}

class _TeachingDetailsState extends State<TeachingDetails> {
  Map<String, dynamic> content={};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    content=teaching_content[widget.title];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Text(content["title"]),
              Image.asset(content["image"]),
              ]
          )
        ),
      ),
    );
  }
  
}