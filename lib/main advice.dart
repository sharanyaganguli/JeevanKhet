import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/products.dart';
import 'package:my_app/AdvicePage.dart';

class MainAdvice extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainAdviceState();
  }
}

class _MainAdviceState extends State<MainAdvice> {
  final Color themeColor = Color(0xFF566017);
  final Color lightThemeColor = Color(0xFF969A2A);
  
  Map<String, dynamic> userData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.uid)
            .get();
        
        if (doc.exists && mounted) {
          setState(() {
            userData = doc.data() as Map<String, dynamic>? ?? {};
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  String _getUserCity() {
    return userData['city']?.toString() ?? 'your location';
  }

  String _getUserCrop() {
    List<dynamic> crops = userData['crops'] ?? [];
    if (crops.isNotEmpty) {
      return crops.first.toString().toLowerCase();
    }
    return 'your crop';
  }

  String _getUserSoilType() {
    String soilType = userData['soil_type']?.toString() ?? '';
    if (soilType.isNotEmpty) {
      return soilType.toLowerCase();
    }
    return 'your soil type';
  }

  String _buildQuery(String queryType) {
    String city = _getUserCity();
    String crop = _getUserCrop();
    String soilType = _getUserSoilType();
    
    // Get current locale
    String currentLocale = EasyLocalization.of(context)?.locale.languageCode ?? 'en';
    String languageInstruction = currentLocale == 'hi' 
        ? " कृपया सरल, रोजमर्रा की हिंदी (हिंदी) में जवाब दें। आसान शब्दों का उपयोग करें जो आम किसान आसानी से समझ सकें। "
        : " Please respond in simple, everyday English language. ";
    
    // Build queries directly with user data
    switch (queryType) {
      case 'soil_preparation':
        return "Give me simple farmer-friendly soil preparation steps for $crop in $soilType in $city.$languageInstruction";
      case 'sowing':
        return "Explain in simple farmer-friendly language how to sow $crop seeds in $soilType in $city.$languageInstruction";
      case 'irrigation':
        return "Explain in simple farmer-friendly language how to irrigate $crop crops sustainably in $soilType in $city.$languageInstruction";
      case 'fertilizers':
        return "Explain in simple farmer-friendly language which fertilizers to use for $crop in $soilType in $city.$languageInstruction";
      case 'pest_control':
        return "Explain in simple farmer-friendly language how to control pests in $crop crops in $soilType in $city.$languageInstruction";
      default:
        return "Give me simple farmer-friendly advice for $crop in $soilType in $city.$languageInstruction";
    }
  }

  /// Reusable button builder
  Widget _buildAdviceButton(
      String title, String queryType, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: themeColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          minimumSize: Size(double.infinity, 40),
          shadowColor: Colors.black45,
          elevation: 5,
        ),
        onPressed: (){
          String personalizedQuery = _buildQuery(queryType);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Soiladvisor(query: personalizedQuery, title: title)),
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
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(
            '🌱 ${'screen_titles.advice'.tr()}',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          backgroundColor: lightThemeColor,
          centerTitle: true,
        ),
        body: Center(
          child: CircularProgressIndicator(color: themeColor),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          '🌱 ${'screen_titles.advice'.tr()}',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: lightThemeColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20,),
            Text("advice.title".tr(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: themeColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text('advice.sub_title'.tr(),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: lightThemeColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50),


            _buildAdviceButton(
              "advice.button1".tr(),
              'soil_preparation',
              Icons.landscape,
            ),
            SizedBox(height: 20,),

            _buildAdviceButton(
              'advice.button2'.tr(),
              'sowing',
              Icons.grass,
            ),
            SizedBox(height: 20,),

            _buildAdviceButton(
              "advice.button3".tr(),
              'irrigation',
              Icons.water_drop,
            ),
            SizedBox(height: 20,),

            _buildAdviceButton(
              "advice.button4".tr(),
              'fertilizers',
              Icons.eco,
            ),
            SizedBox(height: 20,),

            _buildAdviceButton(
              "advice.button5".tr(),
              'pest_control',
              Icons.bug_report,
            ),
          ],
        ),
      ),
    );
  }
}
