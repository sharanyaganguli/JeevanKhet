import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_translate/flutter_translate.dart';
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
          'Teaching',
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
            Text( translate('teaching.title'),
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
              translate('teaching.sub_title'),
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
                TeachingCard(translate("teaching.card1"), "fertilizer.png", lightThemeColor),
                SizedBox(width: 20),
                TeachingCard(translate("teaching.card2"), "plant game.png", lightThemeColor),
              ],
            ),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TeachingCard(translate("teaching.card3"), "seeds.jpg", lightThemeColor),
                SizedBox(width: 20),
                TeachingCard(translate("teaching.card4"), "soil.png", lightThemeColor),
              ],
            ),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TeachingCard(translate("teaching.card5"), "pesticide.png", lightThemeColor),
                SizedBox(width: 20),
                TeachingCard(translate("teaching.card6"), "crops.png", lightThemeColor),

              ],
            )


          ],
        ),
      ),
    );
  }

  Widget TeachingCard(name, image, colour){
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => TeachingDetails(name)));
      },
      child: Container(
        /* padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),*/
        width: MediaQuery.of(context).size.width/2-40,
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(20),

        ),
        child:
        Column(
          children: [
            Container(
                height: 150,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    color: colour,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                ),
                child: Image.asset("assets/$image", width: 150, height: 150)
            ),

            SizedBox(height: 10),
            Text(name, style: TextStyle(fontWeight: FontWeight.w700),),
          ],
        ),
      ),
    );
  }

}
