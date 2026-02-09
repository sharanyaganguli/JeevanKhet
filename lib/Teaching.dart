import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:my_app/products.dart';
import 'package:my_app/main advice.dart';
import 'package:my_app/values.dart';
import 'package:my_app/teaching_details.dart';

class Teaching extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TeachingState();

  }
}

class _TeachingState extends State<Teaching> {

  Widget _buildLearningButton(String title, Widget page) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF969A2A),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 0,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '🌱 ${'screen_titles.teaching'.tr()}',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Color(0xFF969A2A),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Heading
            Text('teaching.title'.tr(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),

            // Subtitle
            Text(
              'teaching.sub_title'.tr(),
              style: TextStyle(
                fontSize: 15,
                color: Colors.black54,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TeachingCard("teaching.card1".tr(), "fertilizer.png", lightThemeColor, "card1"),
                SizedBox(width: 20),
                TeachingCard("teaching.card2".tr(), "plant game.png", lightThemeColor, "card2"),
              ],
            ),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TeachingCard("teaching.card3".tr(), "seeds.jpg", lightThemeColor, "card3"),
                SizedBox(width: 20),
                TeachingCard("teaching.card4".tr(), "soil.png", lightThemeColor, "card4"),
              ],
            ),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TeachingCard("teaching.card5".tr(), "pesticide.png", lightThemeColor, "card5"),
                SizedBox(width: 20),
                TeachingCard("teaching.card6".tr(), "crops.png", lightThemeColor, "card6"),

              ],
            )


          ],
        ),
      ),
    );
  }

  Widget TeachingCard(name, image, colour, cardKey){
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => TeachingDetails(cardKey)));
      },
      child: Container(
        width: MediaQuery.of(context).size.width/2-40,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300, width: 1),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 130,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colour,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Image.asset(
                "assets/$image",
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Center(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
