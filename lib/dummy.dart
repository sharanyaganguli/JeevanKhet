import 'package:flutter/material.dart';

class Dummy extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _DummyState();

  }

}

class _DummyState extends State<Dummy>{
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text("information Page"),
     ),
     body: Container(
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius:BorderRadius.circular(15),
              ),
              minimumSize: Size(200, 50),
                elevation: 5,

            ),
              onPressed: (){
                print("button was pressed");
              },
              child: Text("Click me!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ))
        ],
      ),
     ),
   );
  }

}