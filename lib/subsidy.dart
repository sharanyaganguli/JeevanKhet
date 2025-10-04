import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'main.dart';

class Subsidy extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SubsidyState();
  }
}

class _SubsidyState extends State<Subsidy> {
  String? selectedState;
  String? selectedCity;

  final List<String> states = ["Maharashtra", "Karnataka", "Gujarat"];
  final Map<String, List<String>> cities = {
    "Maharashtra": ["Mumbai", "Pune", "Nagpur"],
    "Karnataka": ["Bengaluru", "Mysuru", "Mangaluru"],
    "Gujarat": ["Ahmedabad", "Surat", "Vadodara"],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Subsidy Page',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Color(0xFF969A2A),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Title
            Text(
              "What prices do you want to check?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 20),

            // State Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Select State",
                border: OutlineInputBorder(),
              ),
              value: selectedState,
              items: states.map((state) {
                return DropdownMenuItem(
                  value: state,
                  child: Text(state),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedState = value;
                  selectedCity = null; // reset city when state changes
                });
              },
            ),

            SizedBox(height: 20),

            // City Dropdown (depends on state)
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Select City",
                border: OutlineInputBorder(),
              ),
              value: selectedCity,
              items: selectedState == null
                  ? []
                  : cities[selectedState]!.map((city) {
                return DropdownMenuItem(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCity = value;
                });
              },
            ),

            SizedBox(height: 30),

            // Market Price Section
            Text(
              "Market Price:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("Low: ₹XXXX", style: TextStyle(fontSize: 14)),
            Text("High: ₹YYYY", style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
