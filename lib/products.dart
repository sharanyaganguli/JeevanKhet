import 'package:flutter/material.dart';
import 'package:my_app/dummy.dart';

class Products extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                ProductCard(context),
                SizedBox(width: 20,),
                ProductCard(context),
        ]
    ),
            SizedBox(height: 20,),
            Row(
                children: [
                  ProductCard(context),
                  SizedBox(width: 20,),
                  ProductCard(context),
                ]
            ),
  ],
      ),
      )
    );
  }

  ProductCard(BuildContext context){
    return GestureDetector(
      onTap: (){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Dummy()));
      },
      child: Container(
          width: MediaQuery.of(context).size.width/2-30,
          height: MediaQuery.of(context).size.height/3,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              color: Color(0xff32a852),
              border: Border.all(width: 4),
              borderRadius: BorderRadius.circular(20)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQFgQqkf8R9JuDKjukEwt-fRQ9Dfo1XR1oD8w&s",
              ),
              Text("⭐⭐⭐", style: TextStyle(fontSize: 22),
                textAlign: TextAlign.left,
              ),
              Text("Product Name", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
              Text("Price: 5000", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                textAlign: TextAlign.left,
              ),
              Text("Product description", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                textAlign: TextAlign.left,
              ),
            ],
          )
      ),
    );
  }

}
