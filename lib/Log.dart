import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

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
        title: Text(translate('Sustainability Game'),
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
            Text(translate("log.title"),
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20), textAlign: TextAlign.center,),
            SizedBox(height: 15),
            Text(translate("log.sub_title"),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500), textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
