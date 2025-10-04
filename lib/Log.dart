import 'package:flutter/material.dart';

class Log extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LogState();
  }
}

class _LogState extends State<Log> {
  bool fertilizer = false;
  bool irrigation = false;
  bool mulching = false;
  bool compost = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JeevanKhet',
            style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: Color(0xFF969A2A),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text("Sustainability Log",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20), textAlign: TextAlign.center,),
            SizedBox(height: 15),
            Text(
              "The more practices you do, the more your plant grows! Every week grow a new plant.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            // Checklist items
            CheckboxListTile(
              title: Text("Used organic fertilizer instead of chemical fertilizer"),
              value: fertilizer,
              onChanged: (bool? value) {
                setState(() {
                  fertilizer = value ?? false;
                });
              },
            ),

            SizedBox(height: 20,),

            SizedBox(height: 10),
            Text("The Sustainability Game",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20), textAlign: TextAlign.center,),
            SizedBox(height: 15),
            Text(
              "To play the game, select one of the best options to help your plant grow! Every week you get a new one",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500), textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
