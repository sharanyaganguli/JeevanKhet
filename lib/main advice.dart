import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:my_app/SoilAdvisor.dart';

class MainAdvice extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainAdviceState();
  }
}

class _MainAdviceState extends State<MainAdvice> {
  final Color themeColor = Color(0xFF566017);
  final Color lightThemeColor = Color(0xFF969A2A);

  getResponse(String query) {
    Gemini.init(
        apiKey: "AIzaSyAcXDXPZbCCypVbvy_TBNxTLtD6hXyH6GE",
        enableDebugging: true);

    Gemini.instance.prompt(parts: [
      Part.text(query),
    ]).then((value) {
      print(value?.output);
    });
  }

  Widget _buildAdviceButton(
      String title, String query, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: themeColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          shadowColor: Colors.black45,
          elevation: 5,
        ),
        onPressed: (){
          getResponse(query);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Soiladvisor()),
          );
        },
        icon: Icon(icon, size: 20, color: Colors.white),
        label: Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // soft background for contrast
      appBar: AppBar(
        title: Text(
          '🌱 JeevanKhet',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: lightThemeColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 38.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20,),
            Text(
              '👩‍🌾 What help do you need today?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: themeColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Tap a button and I’ll guide you step by step 🚜',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: lightThemeColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 100),

            // ✅ Buttons with navigation
            _buildAdviceButton(
              "Ready the Soil",
              "Give me simple farmer-friendly soil preparation steps for rice in silty soil in Mumbai.",
              Icons.landscape,
            ),
            SizedBox(height: 20,),

            _buildAdviceButton(
              "Plant the Seeds",
              "Explain in simple farmer-friendly language how to sow rice seeds in silty soil in Mumbai.",
              Icons.grass,
            ),
            SizedBox(height: 20,),

            _buildAdviceButton(
              "Watering Tips",
              "Explain in simple farmer-friendly language how to irrigate rice crops sustainably in silty soil in Mumbai.",
              Icons.water_drop,
            ),
            SizedBox(height: 20,),

            _buildAdviceButton(
              "Plant Food (Fertilizers)",
              "Explain in simple farmer-friendly language which fertilizers to use for rice in silty soil in Mumbai.",
              Icons.eco,
            ),
            SizedBox(height: 20,),

            _buildAdviceButton(
              "Keep Pests Away",
              "Explain in simple farmer-friendly language how to control pests in rice crops in silty soil in Mumbai.",
              Icons.bug_report,
            ),
          ],
        ),
      ),
    );
  }
}
